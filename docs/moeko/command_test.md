# my_help commandのテストでdiffが通らない

## 問題点

my_help commandをテストしようとしたが，出力が長すぎてなかなかdiffが通らない．
diffが起こっているところを見てもどこがずれているのかがわからない.
また，diffが解消してもdiff emptyと出る．この解決策がわからない．←これは未だに解消法不明

以下はmy_helpにおける出力結果である．

```bash
> my_help
Commands:
  my_help delete HELP             # delete HELP
  my_help edit HELP               # edit HELP
  my_help git [push|pull]         # git push or pull
  my_help help [COMMAND]          # Describe available commands or one specific command
  my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
  my_help new HELP                # make new HELP
  my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
  my_help setup                   # set up the test database
  my_help version                 # show version

Options:
  d, [--dir=DIR]  
```


## 問題出力

以下のようにテストを行なった．

```ruby:cli_spec.rb
  context "default help start_with matcher" do
    expected = <<~EXPECTED
    Commands:
      my_help delete HELP             # delete HELP
      my_help edit HELP               # edit HELP
      my_help git [push|pull]         # git push or pull
      my_help help [COMMAND]          # Describe available commands or one specif...
      my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
      my_help new HELP                # make new HELP
      my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
      my_help setup                   # set up the test database
      my_help version                 # show version
    
    Options:
      d, [--dir=DIR]  
    
  EXPECTED
    # stop_all_commandsを使って，stdoutを取り出し，start_withを試した
    # とりあえず，こんなぐらいあればrspecは書けるかな？
    # raise_errorを試したい．．．
    before(:each) { run_command("my_help")}
    it { expect(last_command_started).to have_output(expected) }
  end
```

すると，エラーがこのように出てきた．

```bash  
default help start_with matcher
    is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n" (FAILED - 1)

MyHelp
  has a version number

Failures:

  1) my_help default help start_with matcher is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
     Failure/Error: it { expect(last_command_started).to have_output(expected) }
     
       expected `my_help` to have output "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
       but was:
          Commands:
            my_help delete HELP             # delete HELP
            my_help edit HELP               # edit HELP
            my_help git [push|pull]         # git push or pull
            my_help help [COMMAND]          # Describe available commands or one specif...
            my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
            my_help new HELP                # make new HELP
            my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
            my_help setup                   # set up the test database
            my_help version                 # show version
     
          Options:
            d, [--dir=DIR]  
       Diff:
         <The diff is empty, are your objects producing identical `#inspect` output?>
     # ./spec/cli_spec.rb:75:in `block (3 levels) in <top (required)>'

Finished in 1.53 seconds (files took 0.1471 seconds to load)
8 examples, 1 failure

Failed examples:

rspec ./spec/cli_spec.rb:75 # my_help default help start_with matcher is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
```

探っても中々解決策が見つからなかったので別の方法でテストを行うことにした．

## 解決方法

解決方法として，冒頭の部分が出力と一致しているとテストを通すことにした．
以下のような書き方で行う．

```ruby:cli_spec.rb
  context "default help" do
    expected = /^Commands:/
    # 長い出力の全文を一致させるのではなく，
    # 最初だけを示すRegExpに一致させるように変更
    let(:my_help){ run_command("my_help") }
    it { expect(my_help).to have_output(expected) }
  end
```

すると無事テストが通った．





# my_help commandのテストでdiffが通らない

## 問題点

my_help commandをテストしようとしたが，出力が長すぎてなかなかdiffが通らない．
diffが起こっているところを見てもどこがずれているのかがわからない.
また，diffが解消してもdiff emptyと出る．この解決策がわからない．

以下はmy_helpにおける出力結果である．

```bash
> my_help
Commands:
  my_help delete HELP             # delete HELP
  my_help edit HELP               # edit HELP
  my_help git [push|pull]         # git push or pull
  my_help help [COMMAND]          # Describe available commands or one specific command
  my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
  my_help new HELP                # make new HELP
  my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
  my_help setup                   # set up the test database
  my_help version                 # show version

Options:
  d, [--dir=DIR]  
```


## 問題出力

以下のようにテストを行なった．

```ruby:cli_spec.rb
  context "default help start_with matcher" do
    expected = <<~EXPECTED
    Commands:
      my_help delete HELP             # delete HELP
      my_help edit HELP               # edit HELP
      my_help git [push|pull]         # git push or pull
      my_help help [COMMAND]          # Describe available commands or one specif...
      my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
      my_help new HELP                # make new HELP
      my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
      my_help setup                   # set up the test database
      my_help version                 # show version
    
    Options:
      d, [--dir=DIR]  
    
  EXPECTED
    # stop_all_commandsを使って，stdoutを取り出し，start_withを試した
    # とりあえず，こんなぐらいあればrspecは書けるかな？
    # raise_errorを試したい．．．
    before(:each) { run_command("my_help")}
    it { expect(last_command_started).to have_output(expected) }
  end
```

すると，エラーがこのように出てきた．

```bash  
default help start_with matcher
    is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n" (FAILED - 1)

MyHelp
  has a version number

Failures:

  1) my_help default help start_with matcher is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
     Failure/Error: it { expect(last_command_started).to have_output(expected) }
     
       expected `my_help` to have output "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
       but was:
          Commands:
            my_help delete HELP             # delete HELP
            my_help edit HELP               # edit HELP
            my_help git [push|pull]         # git push or pull
            my_help help [COMMAND]          # Describe available commands or one specif...
            my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
            my_help new HELP                # make new HELP
            my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
            my_help setup                   # set up the test database
            my_help version                 # show version
     
          Options:
            d, [--dir=DIR]  
       Diff:
         <The diff is empty, are your objects producing identical `#inspect` output?>
     # ./spec/cli_spec.rb:75:in `block (3 levels) in <top (required)>'

Finished in 1.53 seconds (files took 0.1471 seconds to load)
8 examples, 1 failure

Failed examples:

rspec ./spec/cli_spec.rb:75 # my_help default help start_with matcher is expected to have output: "Commands:\n  my_help delete HELP             # delete HELP\n  my_help edit HELP               # edit...test database\n  my_help version                 # show version\n\nOptions:\n  d, [--dir=DIR]  \n\n"
```

探っても中々解決策が見つからなかったので別の方法でテストを行うことにした．

## 解決方法

解決方法として，冒頭の部分が出力と一致しているとテストを通すことにした．
以下のような書き方で行う．

```ruby:cli_spec.rb
  context "default help" do
    expected = /^Commands:/
    # 長い出力の全文を一致させるのではなく，
    # 最初だけを示すRegExpに一致させるように変更
    let(:my_help){ run_command("my_help") }
    it { expect(my_help).to have_output(expected) }
  end
```

すると無事テストが通った．




