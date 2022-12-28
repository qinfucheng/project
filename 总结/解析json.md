# 概述

JSON的全称为：JavaScript Object Notation，顾名思义，JSON是用于标记Javascript对象的，JSON官方的解释为：JSON是一种轻量级的数据传输格式。本文并不详细介绍JSON本身的细节，旨在记录及介绍如何使用C++语言来处理[JSON](https://link.jianshu.com?t=http://www.json.org。http://json.org/json-zh.html)

# 使用JsonCPP库处理

Jsoncpp是个跨平台的开源库，首先从[https://github.com/open-source-parsers/jsoncpp](https://link.jianshu.com?t=https://github.com/open-source-parsers/jsoncpp) 上下载jsoncpp库源码。关于Jsoncpp代码的编译这里就不多说了，在jsoncpp/makefiles/目录里有msvc2010和vs71两个文件夹，根据windows本地安装的编译器，找到相应目录下的jsoncpp.sln，双击打开运行，默认生成静态链接库。 在工程中引用，只需要include/json及.lib文件即可。当然，也可以直接将源码文件加入到自己的工程目录下，跟随你的源码一起编译到程序里面，这样也相当于实现了跨平台

# JsonCPP类简介

jsoncpp中所有对象、类名都在namespace Json中，包含json.h即可。Jsoncpp主要包含以下三个类：

- Json::Value 是jsoncpp中最基本、最重要的类，用于表示各种类型的对象，jsoncpp支持的对象类型可见Json::ValueType枚举值。Json::Value 只能处理 ANSI 类型的字符串，如果 C++ 程序是用 Unicode 编码的，最好加一个 Adapt 类来适配。
- Json::Reader 将json文件流或字符串解析到Json::Value, 主要函数有Parse。
- Json::Writer 与Json::Reader相反，将Json::Value转化成字符串流，由于Json::Writer类是一个纯虚类，并不能直接使用，我们使用它的两个子类：Json::FastWriter和Json::StyleWriter，分别输出不带格式的json和带格式的json。

## **a) 将信息保存为Json格式**

```cpp
#include <iostream>
#include <fstream> 
#include "json/json.h"
using namespace std;
int main()
{
    //根节点
    Json::Value root;
 
    //根节点属性
    root["name"] = Json::Value("Tsybius");
    root["age"] = Json::Value(23);
    root["sex_is_male"] = Json::Value(true);
 
    //子节点
    Json::Value partner;
 
    //子节点属性
    partner["partner_name"] = Json::Value("Galatea");
    partner["partner_age"] = Json::Value(21);
    partner["partner_sex_is_male"] = Json::Value(false);
 
    //子节点挂到根节点上
    root["partner"] = Json::Value(partner);
 
    //数组形式
    root["achievement"].append("ach1");
    root["achievement"].append("ach2");
    root["achievement"].append("ach3");
     
    //直接输出控制台
    cout << "FastWriter:" << endl;
    Json::FastWriter fw;
    cout << fw.write(root) << endl << endl;
 
    //缩进输出到控制台
    cout << "StyledWriter:" << endl;
    Json::StyledWriter sw;
    cout << sw.write(root) << endl << endl;
     
    //输出到文件
    ofstream os;
    os.open("PersonalInfo");
    os << sw.write(root);
    os.close();
 
    return 0;
}
```

**控制台输出信息如下**：

![1671968915988](C:\Users\DELL\Desktop\总结\图片\1671968915988.jpg)

生成的PersonalInfo文件内容如下：

```json
{
   "achievement" : [ "ach1", "ach2", "ach3" ],
   "age" : 23,
   "name" : "Tsybius",
   "partner" : {
      "partner_age" : 21,
      "partner_name" : "Galatea",
      "partner_sex_is_male" : false
   },
   "sex_is_male" : true
}
```

## **b) 从字符串中解析Json**

```cpp
#include <iostream>
 
#include "json/json.h"
 
using namespace std;
 
int main()
{
    //字符串
    const char* str = 
        "{\"praenomen\":\"Gaius\",\"nomen\":\"Julius\",\"cognomen\":\"Caezar\","
        "\"born\":-100,\"died\":-44}";
 
    Json::Reader reader;
    Json::Value root;
 
    //从字符串中读取数据
    if(reader.parse(str,root))
    {
        string praenomen = root["praenomen"].asString();
        string nomen = root["nomen"].asString();
        string cognomen = root["cognomen"].asString();
        int born = root["born"].asInt();
        int died = root["died"].asInt();
 
        cout << praenomen + " " + nomen + " " + cognomen
            << " was born in year " << born 
            << ", died in year " << died << endl;
    }
 
    return 0;
}
```

## **c) 从文件中解析Json**

 待解析的Json格式文件如下：

```json
{
    "name":"Tsybius",
    "age":23,
    "sex_is_male":true,
    "partner":
    {
        "partner_name":"Galatea",
        "partner_age":21,
        "partner_sex_is_male":false
    },
    "achievement":["ach1","ach2","ach3"]
}
```

**解析Json文件代码如下：**

```cpp
#include <iostream>
#include <fstream>
 
#include "json/json.h"
 
using namespace std;
 
int main()
{
    Json::Reader reader;
    Json::Value root;
 
    //从文件中读取
    ifstream is;
    is.open("PersonalInfo.json", ios::binary);
 
    if(reader.parse(is,root))
    {
        //读取根节点信息
        string name = root["name"].asString();
        int age = root["age"].asInt();
        bool sex_is_male = root["sex_is_male"].asBool();
 
        cout << "My name is " << name << endl;
        cout << "I'm " << age << " years old" << endl;
        cout << "I'm a " << (sex_is_male ? "man" : "woman") << endl;
 
        //读取子节点信息
        string partner_name = root["partner"]["partner_name"].asString();
        int partner_age = root["partner"]["partner_age"].asInt();
        bool partner_sex_is_male = root["partner"]["partner_sex_is_male"].asBool();
 
        cout << "My partner's name is " << partner_name << endl;
        cout << (partner_sex_is_male ? "he" : "she") << " is "
            << partner_age << " years old" << endl;
 
        //读取数组信息
        cout << "Here's my achievements:" << endl;
        for(int i = 0; i < root["achievement"].size(); i++)
        {
            string ach = root["achievement"][i].asString();
            cout << ach << '\t';
        }
        cout << endl;
 
        cout << "Reading Complete!" << endl;
    }
 
    is.close();
 
    return 0;
}
```

**d) 向文件中插入Json数据**

```cpp
#include <iostream>
#include <fstream>
 
#include "json/json.h"
 
using namespace std;
 
int main()
{
    Json::Reader reader;
    Json::Value root;
 
    //从文件中读取
    ifstream is;
    is.open("PersonalInfo.json", ios::binary);
 
    if(reader.parse(is,root))
    { 
        Json::Value arrayObj = root["achievement"];   // 构建对象  
        Json::Value new_item, new_item1;  
        new_item["date"] = "2011-11-11";  
        new_item1["time"] = "11:11:11";  
        arrayObj.append(new_item);  // 插入数组成员  
        arrayObj.append(new_item1); // 插入数组成员  
 
        std::string out = root.toStyledString();  
        // 输出无格式json字符串  
        Json::FastWriter writer;  
        std::string strWrite = writer.write(root);
        std::ofstream ofs;
        ofs.open("test_write.json");
        ofs << strWrite;
        ofs.close();
        cout << "Insert Complete!" << endl;
    }
 
    is.close();
 
    return 0;
}
```

# 总结

- 关于解析为布尔类型问题：
   写入数值0，解析为布尔类型false，其他数值解析为true
   写入空字符串，解析为布尔类型false，其他字符串均解析为true
- 关于解析为数值类型的问题：
   写入布尔类型，true解析为1，false解析为0
   写入字符串类型，解析会crash
- 关于解析为字符串类型的问题：
   写入布尔类型，true解析为“true”，false解析为“false”
   写入数值类型，解析会crash

