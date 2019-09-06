## 一、环境
需要先安装Java


## 二、安装和启动ES
```
 wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.0.zip
 
 unzip elasticsearch-5.6.0.zip
 
 cd elasticsearch-5.6.0/ 
 
 ./bin/elasticsearch
```

如果这时报错"max virtual memory areas vm.maxmapcount [65530] is too low"，要运行下面的命令。
```
sudo sysctl -w vm.max_map_count=262144
```


## 三、中文分词设置
```
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.6.0/elasticsearch-analysis-ik-5.6.0.zip
```
版本需要与es保持一致，重启

```
curl -X PUT 'localhost:9200/accounts' -d '
{
  "mappings": {
    "person": {
      "properties": {
        "user": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "title": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "desc": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        }
      }
    }
  }
}'
```


