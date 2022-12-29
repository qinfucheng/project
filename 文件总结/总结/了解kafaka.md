# 1、Kafka架构

它的架构包括以下组件：`Kafka` 是一个分布式[流媒体](https://so.csdn.net/so/search?q=流媒体&spm=1001.2101.3001.7020)平台，`kafka`官网：http://kafka.apache.org/

- 话题（Topic）：是特定类型的消息流。消息是字节的有效负载（Payload），话题是消息的分类名或种子（Feed）名。
- 生产者（Producer）：是能够发布消息到话题的任何对象。
- 服务代理（Broker）：已发布的消息保存在一组服务器中，它们被称为代理（Broker）或[Kafka](https://so.csdn.net/so/search?q=Kafka&spm=1001.2101.3001.7020)集群。
- 消费者（Consumer）：可以订阅一个或多个话题，并从Broker拉数据，从而消费这些已发布的消息。

# 2、**Kafka存储策略**

1）kafka以topic来进行消息管理，每个topic包含多个partition，每个partition对应一个逻辑log，有多个segment组成。

2）每个segment中存储多条消息（见下图），消息id由其逻辑位置决定，即从消息id可直接定位到消息的存储位置，避免id到位置的额外映射。

3）每个part在内存中对应一个index，记录每个segment中的第一条消息偏移。

4）发布者发到某个topic的消息会被均匀的分布到多个partition上（或根据用户指定的路由规则进行分布），broker收到发布消息往对应partition的最后一个segment上添加该消息，当某个segment上的消息条数达到配置值或消息发布时间超过阈值时，segment上的消息会被flush到磁盘，只有flush到磁盘上的消息订阅者才能订阅到，segment达到一定的大小后将不会再往该segment写数据，broker会创建新的segment。

# 3、Kafka删除策略

1）N天前的删除。

2）保留最近的MGB数据。

# 4、Kafka broker

与其它消息系统不同，Kafka broker是无状态的。这意味着消费者必须维护已消费的状态信息。这些信息由消费者自己维护，broker完全不管（有offset managerbroker管理）。

- 从代理删除消息变得很棘手，因为代理并不知道消费者是否已经使用了该消息。Kafka创新性地解决了这个问题，它将一个简单的基于时间的SLA应用于保留策略。当消息在代理中超过一定时间后，将会被自动删除。
- 这种创新设计有很大的好处，消费者可以故意倒回到老的偏移量再次消费数据。这违反了队列的常见约定，但被证明是许多消费者的基本特征。

以下摘抄自kafka官方文档：

# 5、Kafka Design

## 目标

\1) 高吞吐量来支持高容量的事件流处理

\2) 支持从离线系统加载数据

\3) 低延迟的消息系统

## 持久化

\1) 依赖文件系统，持久化到本地

\2) 数据持久化到log

## 效率

### 1) 解决”small IO problem“：

使用”message set“组合消息。

server使用”chunks of messages“写到log。

consumer一次获取大的消息块。

### 2）解决”byte copying“：

在producer、broker和consumer之间使用统一的binary message format。

使用系统的pagecache。

使用sendfile传输log，避免拷贝。

端到端的批量压缩（End-to-end Batch Compression）

Kafka支持GZIP和Snappy压缩协议。

## 6、The Producer

## 负载均衡

1）producer可以自定义发送到哪个partition的路由规则。默认路由规则：hash(key)%numPartitions，如果key为null则随机选择一个partition。

2）自定义路由：如果key是一个user id，可以把同一个user的消息发送到同一个partition，这时consumer就可以从同一个partition读取同一个user的消息。

## 异步批量发送

批量发送：配置不多于固定消息数目一起发送并且等待时间小于一个固定延迟的数据。

# 7、The Consumer

consumer控制消息的读取。

## **Push vs Pull**

1)producer push data to broker，consumer pull data from broker

2)consumer pull的优点：consumer自己控制消息的读取速度和数量。

3)consumer pull的缺点：如果broker没有数据，则可能要pull多次忙等待，Kafka可以配置consumer long pull一直等到有数据。

## **Consumer Position**

1)大部分消息系统由broker记录哪些消息被消费了，但Kafka不是。

2)Kafka由consumer控制消息的消费，consumer甚至可以回到一个old offset的位置再次消费消息。

## **Message Delivery Semantics**

三种：

```
At most once—Messages may be lost but are never redelivered.

At least once—Messages are never lost but may be redelivered.

Exactly once—this is what people actually want, each message is delivered once and only once.
```

Producer：有个”acks“配置可以控制接收的leader的在什么情况下就回应producer消息写入成功。

Consumer：

```
* 读取消息，写log，处理消息。如果处理消息失败，log已经写入，则无法再次处理失败的消息，对应”At most once“。

\* 读取消息，处理消息，写log。如果消息处理成功，写log失败，则消息会被处理两次，对应”At least once“。

\* 读取消息，同时处理消息并把result和log同时写入。这样保证result和log同时更新或同时失败，对应”Exactly once“。

Kafka默认保证at-least-once delivery，容许用户实现at-most-once语义，exactly-once的实现取决于目的存储系统，kafka提供了读取offset，实现也没有问题。
```

## 复制（Replication）

```
1）一个partition的复制个数（replication factor）包括这个partition的leader本身。

2）所有对partition的读和写都通过leader。

3）Followers通过pull获取leader上log（message和offset）

4）如果一个follower挂掉、卡住或者同步太慢，leader会把这个follower从”in sync replicas“（ISR）列表中删除。

5）当所有的”in sync replicas“的follower把一个消息写入到自己的log中时，这个消息才被认为是”committed“的。

6）如果针对某个partition的所有复制节点都挂了，Kafka选择最先复活的那个节点作为leader（这个节点不一定在ISR里）。
```

## **日志压缩（Log Compaction）**

```
1）针对一个topic的partition，压缩使得Kafka至少知道每个key对应的最后一个值。

2）压缩不会重排序消息。

3）消息的offset是不会变的。

4）消息的offset是顺序的。
```

# **8、Distribution**

## **Consumer Offset Tracking**

```
1）High-level consumer记录每个partition所消费的maximum offset，并定期commit到offset manager（broker）。

2）Simple consumer需要手动管理offset。现在的Simple consumer Java API只支持commit offset到zookeeper。
```

## **Consumers and Consumer Groups**

```
1）consumer注册到zookeeper

2）属于同一个group的consumer（group id一样）平均分配partition，每个partition只会被一个consumer消费。

3）当broker或同一个group的其他consumer的状态发生变化的时候，consumer rebalance就会发生。
```

## **Zookeeper协调控制**

```
1）管理broker与consumer的动态加入与离开。

2）触发负载均衡，当broker或consumer加入或离开时会触发负载均衡算法，使得一个consumer group内的多个consumer的订阅负载平衡。

3）维护消费关系及每个partition的消费信息。
```

# 9、Kafka技术概览

## 9.1、 Kafka的特性

**高吞吐量、低延迟：**kafka每秒可以处理几十万条消息，它的延迟最低只有几毫秒
**可扩展性：**kafka集群支持热扩展
**持久性、可靠性：**消息被持久化到本地磁盘，并且支持数据备份防止数据丢失
**容错性：**允许集群中节点失败（若副本数量为n,则允许n-1个节点失败）
**高并发：**支持数千个客户端同时读写

## 9.2、 Kafka一些重要设计思想

下面介绍先大体介绍一下Kafka的主要设计思想，可以让相关人员在短时间内了解到kafka相关特性，如果想深入研究，后面会对其中每一个特性都做详细介绍。

**Consumergroup：**各个consumer可以组成一个组，每个消息只能被组中的一个consumer消费，如果一个消息可以被多个consumer消费的话，那么这些consumer必须在不同的组。
消息状态：在Kafka中，消息的状态被保存在consumer中，broker不会关心哪个消息被消费了被谁消费了，只记录一个offset值（指向partition中下一个要被消费的消息位置），这就意味着如果consumer处理不好的话，broker上的一个消息可能会被消费多次。
**消息持久化：**Kafka中会把消息持久化到本地文件系统中，并且保持极高的效率。
**消息有效期：**Kafka会长久保留其中的消息，以便consumer可以多次消费，当然其中很多细节是可配置的。
**批量发送：**Kafka支持以消息集合为单位进行批量发送，以提高push效率。
push-and-pull : Kafka中的Producer和consumer采用的是push-and-pull模式，即Producer只管向broker push消息，consumer只管从broker pull消息，两者对消息的生产和消费是异步的。
**Kafka集群中broker之间的关系：**不是主从关系，各个broker在集群中地位一样，我们可以随意的增加或删除任何一个broker节点。
**负载均衡方面：** Kafka提供了一个 metadata API来管理broker之间的负载（对Kafka0.8.x而言，对于0.7.x主要靠zookeeper来实现负载均衡）。
**同步异步：**Producer采用异步push方式，极大提高Kafka系统的吞吐率（可以通过参数控制是采用同步还是异步方式）。
分区机制partition：Kafka的broker端支持消息分区，Producer可以决定把消息发到哪个分区，在一个分区中消息的顺序就是Producer发送消息的顺序，一个主题中可以有多个分区，具体分区的数量是可配置的。分区的意义很重大，后面的内容会逐渐体现。
**离线数据装载：**Kafka由于对可拓展的数据持久化的支持，它也非常适合向Hadoop或者数据仓库中进行数据装载。
**插件支持：**现在不少活跃的社区已经开发出不少插件来拓展Kafka的功能，如用来配合Storm、Hadoop、flume相关的插件。

## 9.3、 kafka 应用场景

**日志收集：**一个公司可以用Kafka可以收集各种服务的log，通过kafka以统一接口服务的方式开放给各种consumer，例如hadoop、Hbase、Solr等。
**消息系统：**解耦和生产者和消费者、缓存消息等。
**用户活动跟踪：**Kafka经常被用来记录web用户或者app用户的各种活动，如浏览网页、搜索、点击等活动，这些活动信息被各个服务器发布到kafka的topic中，然后订阅者通过订阅这些topic来做实时的监控分析，或者装载到hadoop、数据仓库中做离线分析和挖掘。
**运营指标：**Kafka也经常用来记录运营监控数据。包括收集各种分布式应用的数据，生产各种操作的集中反馈，比如报警和报告。
**流式处理：**比如spark streaming和storm
**事件源**
