# Iterable-cli

Sample tool to upload a csv of user data to Iterable 

### Prerequisites
* Bundler
* Ruby-2.1.5

### Installing
Clone the repo and run `bundle` to install gems

### Usage
API key can be saved in .env (see sample.env) or specified via command line option. Default file path is users.csv, can also be specified via command line option

```
$ ./iterable.rb -h
Usage: iterable.rb [$options]                                                                                                                                        ]
    -b, --bulk                       perform bulk update
    -k, --key KEY                    specify api key
    -f, --file path                  specify path to users file
    -v, --verbose                    log everything

$./iterable.rb -b
Time: 00:00:06  ETA: 00:01:17  7.31% [==                                       ]

$ ./iterable.rb -v -k "API KEY" -f "users.csv" -b
custom api key specified via flag: API KEY
custom csv path specified: users.csv
Updating users in bulk
401: BadApiKey (Invalid API key)
```

iterableBulk.rb is just a clone of iterable.rb with bulk set to true by default

