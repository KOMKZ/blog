```dsl
{
    "query": {
        "match_all": {}
    }
}
```

A query clause typically has this structure:
```dsl
{
    QUERY_NAME: {
        ARGUMENT: VALUE,
        ARGUMENT: VALUE,...
    }
}
```


If it references one particular field, it has this structure:
```dsl
{
    QUERY_NAME: {
        FIELD_NAME: {
            ARGUMENT: VALUE,
            ARGUMENT: VALUE,...
        }
    }
}
```

```dsl
{
    "query": {
        "match": {
            "tweet": "elasticsearch"
        }
    }
}
```

```dsl
{
    "bool": {
        "must":     { "match": { "tweet": "elasticsearch" }},
        "must_not": { "match": { "name":  "mary" }},
        "should":   { "match": { "tweet": "full text" }},
        "filter":   { "range": { "age" : { "gt" : 30 }} }
    }
}
```
