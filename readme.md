# Iterable-cli

Sample tool to upload a csv of user data to Iterable 

### Prerequisites
Bundler
Ruby-2.1.5

### Installing
Clone the repo and run `bundle` to install gems

### Usage

```
./iterable.rb -h
Usage: iterable.rb [$options]                                                                                                                                        ]
    -b, --bulk                       perform bulk update
    -k, --key KEY                    specify api key
    -f, --file path                  specify path to users file
    -v, --verbose                    log everything
```

iterableBulk.rb is just a clone of iterable.rb with bulk set to true by default

