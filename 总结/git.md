# 0】版本管理工具介绍

```
1.本地
		只能单人开发使用
		最原始的，无法协同开发	
2.集中式
	必须在联网的情况下
	将项目放入了 服务器中 客户端，只能联网在服务器中写入
	客户端没有源码
3.分布式
	每一用户都相当于一个服务器
```

# 1】git基本命令

​	1-安装git		

```
sudo apt-get install git
```

​	2-创建一个仓库	

```
git init 路径/仓库名
			会在仓库中生成一个.git仓库控制文件
```

​			

3-git框架
	

```
工作区			暂存区			本地仓库(版本库)			远程仓库
				|								 		|
				|          不可见                		|		github
	git init	|                                		|		gitee(码云)
	mkdir		|                                		|		自己搭建
	已提交		|                                		|
	已修改		|                                		|
	已暂存		|                                		|
	
		注意：工作区内容无法直接将项目提交到本地仓库（版本库）
```

4-向暂存区中提交	

```
git add 文件名
	（在git中 . 代表所有文件）	
```

5-查看工作区中的状态

```
	git status	
```

6-.git文件解释	

```
branches			老版本使用使用分支时使用的目录
	COMMIT_EDITMSG		版本注释目录
	config				配置
		[core]
			repositoryformatversion = 0		1表示未来版本兼容
			filemode = true					文件对比diff
			bare = false					设为裸仓库 裸仓库一般用于(搭建)远程仓库
			logallrefupdates = true			记录更新 引用更新
	description								描述用户
	HEAD									实际头所在位置
	index									索引
	info									信息提供
		exclude								设置排除文件
	log										log信息
	objects									对象库，包括 提交的文件、树对象、二进制对象、标签对象
	ref										标识每个分支提交的内容
```

7-将暂存区中的内容提交到本地仓库中	

```
git commit -m "注释"
	git commit -a -m "注释"		//将建立索引后的文件直接从工作区提交到本地仓库
```

8-配置用户信息

```
	//配置用户信息
	git config --global user.name "lili"
	git config --global user.email "2383265374@qq.com"
	
	//配置当前仓库用户信息
	git config  user.name "lili"
	git config  user.email "2383265374@qq.com"
```

9-查看生成的对象类型及/内容

```
git cat-file -p 生成的对象哈希码（可以是头节点，树节点，文件节点）
					（输入十六进制哈希码的前四位就可以）
```

10-查看log信息，提交信息

```
	git log
	git reflog	
```

11-列出用户配置信息

```
	git config --list	
```

12-将暂存区中的内容恢复到工作区

```
git checkout 文件名	
```

13-将老版本中存在的文件恢复到暂存区

```
git reset 版本的仓库头  文件名
		git reset 007407c 1.c	//将007407c头指向的版本树中1.c文件恢复到暂存区
		--》注意不能直接恢复到工作区，需要使用checkout恢复		
```

14-将当前版本库中的内容恢复到暂存区中

```
	git reset 文件名
	（git reset HEAD 文件名）
```

15-直接回退到指定头（不推荐，容易做成游离的对象头节点）

```
	git reset --hard 哈希值
```

# 2】分支操作

1.查看分支

```
git branch	
```

2.创建分支

```
git branch 分支名
```

3.切换分支
	git checkout 分支名
4.分支间的对比
	git diff 分支名1  分支名2	
5.合并
	git merge 要合并的分支
		1-当分支节点没有变化时，不是合并是分支后移
		2-工作区中提交前的文件，最后属于哪个分支，由提交所在分支决定		
6.图形化显示合并过程
	git log --graph --pretty=oneline --abbrev-commit	
7.创建分支并切换
	git checkout -b 分支名
8.删除一个分支
	git branch -d 分支名
		--如果不是在源分支下删除会提示未完全合并分支使用-D强制删除
		--若改变分支后未合并直接删除也会报上面问题

3远程仓库		
1.注册码云（gitee）

2.生成ssh公钥

```
Ubuntu：ssh-keygen -t rsa -C "邮箱"
		公钥路径：
			默认的为： ~/.ssh/id_rsa.pub
						cat id_rsa.pub
```

3.添加公钥

```
点击 主页头像（右上角） --》选择设置 --》选择安全设置 --》ssh公钥
```

4.将gitee中仓库地址（ssh）复制下来并测试

```
	在ubuntu下使用ssh -T git@gitee.com
```

5.在本地创建远程仓库

```
	git remote add 自己起的远程仓库名 仓库地址	
```

6.将本地分支推送到远程分支（最初）

```
	git push -u origin master 
		-u			第一次向远程仓库推送时加	
```

7.当创建远程仓库时非裸仓库，需要强制将远程仓库拉取到当前本地仓库

```
	git pull --rebase origin master	
```

8.将本地分支推送到远程分支

```
git push 仓库名 本地分支:远程分支		// ":"后是指定远程分支	
```

9.将远程分支拉取到本地分支

```
	git pull 仓库名 远程分支:本地分支	
```

10.克隆仓库

```
	git clone	仓库地址	
```

11.删除远程仓库

```
	git remote rm 仓库名
```

# 3】对比

```
	（在Linu下是存在diff对比工具的，但是无法对比git的分支版本等）
	git diff file1  file2
		-->file可以是版本库，也可以是分支，也可以是文件等		
```

# 4】标签

	0.标签和分支的区别
		标签是点，分支是线	
	1.给当前版本打标签
		git tag 标签名	
	2.打标签的时候添加注释
		git tag -a 标签名 -m "注释信息"
	3.查看标签名和注释信息
		git tag -n
	4.将当前标签上传到对应的仓库中
		git push 仓库名 标签名
		git push 仓库名 --tags	（将本地一并上传上去）
	5.删除本地/远程标签
		git tag -d 标签名
		git push 仓库名 :refs/tags/标签名

# 5】整理及压缩

```
git gc
		--将版本库中离散的文件这里成一个包pack	将树整理成idx
```

​		
​		