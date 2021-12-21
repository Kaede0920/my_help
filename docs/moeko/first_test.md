# 最初のテストHello

最初のテストとしてHelloをテストしていく．

chmodファイル名やディレクトリーのアクセス権を変更できる．
下記では全ての権限を実行可能にしている．

```
chmod a+x exe/learner         
```   

chmodについて参考資料

[chmodとは](https://xtech.nikkei.com/it/article/COLUMN/20060227/230728/)



## Helloをlib(library)に作成する．


```learner/lib/learner.rb
require_relative "hello_thor/version"

module HelloThor
  class Error < StandardError; end
  # Your code goes here...

  class Hello
    def run
      name = name || 'world'
      return "Hello #{name}."
    end
  end
end
```

以下のように実行すると，

```bash
> bundle exec exe/learner 
```


エラーが表示．

```
~中略~
最後行
/Users/higashibatamoeko/learner/lib/learner.rb:9:in `run': wrong number of arguments (given 1, expected 0) (ArgumentError)

```

runが引数不足ということなので，

```learner/lib/learner.rb
require_relative "hello_thor/version"

module HelloThor
  class Error < StandardError; end
  # Your code goes here...

  class Hello
    def run(name = nil)
      name = name || 'world'
      return "Hello #{name}."
    end
  end
end
```

もう一度実行すると，

```bash
> bundle exec exe/learner                                                        
Hello world.
```

注意
- class名はキャメルケースで書く．

## Rspecに書き換え

最初に，

```bash
> rake spec
```

testをやっているようなもの．

すると，エラーがでる．それに従って直していく．

エラーの内容．

```bash
~中略~
Learner
  has a version number
  does something useful (FAILED - 1)

Failures:

  1) Learner does something useful
     Failure/Error: expect(false).to eq(true)
     
       expected: true
            got: false
     
       (compared using ==)
     
       Diff:
       @@ -1 +1 @@
       -true
       +false
       
     # ./spec/learner_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.01035 seconds (files took 0.06824 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./spec/learner_spec.rb:8 # Learner does something useful

~以下省略~
```

エラー内容をみると，
spec/learner_spec.rb:8 # Learner does something useful
ここが失敗していると出ている！

中身を見てみると，

```spec/hello_thor_spec.rb
# frozen_string_literal: true

RSpec.describe HelloThor do
  it "has a version number" do
    expect(HelloThor::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end
```
does something usefulを変えていく．


```spec/learner_spec.rb
# frozen_string_literal: true

RSpec.describe Learner do
  it "has a version number" do
    expect(Learner::VERSION).not_to be nil
  end

  describe "HelloThor::Hello" do
    subject(:hello) {Learner::Hello.new}

    describe "run with no arg" do
      it {expect(hello.run).to eq('Hello world.')}
    end

    describe "run with an arg 'Moeko'" do
      it {expect(hello.run('Moeko')).to eq('Hello Moeko.')}
    end

  end
end
```


RSpec参考資料

[basic structure('describe/it')]("https://relishapp.com/rspec/rspec-core/v/3-8/docs/example-groups/basic-structure-describe-it")
[The RSpec Style Guide]('https://rspec.rubystyle.guide/#introduction')

- describeは記述するということ．
- subjectは主語(誰が？)今回はlearnerのhelloが．．．となる.


## Thor

まず，Thorを入れなければいけないが，それは前記事にて説明済み.


現在，以下のように打つと，

```bash
> bundle exec exe/learner
```

```
Hello world.
```

と返ってくるだけだが，これをhelp画面がかえってくるようにしたい．

```lib/cli.rb
# frozen_string_literal: true

require_relative "learner/version"
require 'thor'

module Learner
  class CLI < Thor
    desc 'version', 'version'
    def version
      puts Learner::VERSION
    end

    desc 'hello', 'hello'
    def hello(argv=nil)
      puts Learner::Hello.new.run(argv)
    end
  end
end
```

次にCLIを呼ぶ.
元々classを呼んでいた，Learner::Hello.new.run(ARGV.shift)はコメントアウトして，以下のようにする．

```exe/learner
#!/usr/bin/env ruby

require "learner"
require "cli"

Learner::CLI.start(ARGV)
```

以下のように実行すると，help画面として出てきた．

```bash
bundle exec exe/learner                                                      208ms  木 12/ 2 14:06:47 2021
Commands:
  learner hello           # hello
  learner help [COMMAND]  # Describe available commands or one specific command
  learner version         # version
```

## Aruba

CLAをテストするのを手助けしてくれるもの．


```spec/cli_spec.rb
 1  require 'spec_helper'
 2  
 3  RSpec.describe 'hello_thor', type: :aruba do
 4    context 'version option' do
 5      before(:each) { run_command ('hello_thor version') }
 6      it { expect(last_command_started).to be_successfully_executed }
 7      it { expect(last_command_started).to have_output("0.1.0") }
 8    end
 9  
10    context 'hello option' do
11      before(:each) { run_command ('hello_thor hello') }
12      it { expect(last_command_started).to be_successfully_executed }
13      it { expect(last_command_started).to have_output("Hello world.") }
14    end
15  
16    context 'hello option' do
17      before(:each) { run_command ('hello_thor hello Rudy') }
18      it { expect(last_command_started).to be_successfully_executed }
19      it { expect(last_command_started).to have_output("Hello Rudy.") }
20    end
21  end
```

これをテストすると，

```bash
> bundle exec rspec spec/cli_spec.rb

hello_thor
  # version option
    is expected to be successfully executed
    is expected to have output: "0.1.0"
  # hello without no option
    is expected to be successfully executed
    is expected to have output: "Hello world."
  # hello with Rudy
    is expected to be successfully executed
    is expected to have output: "Hello Rudy."
  # default help
    is expected to be successfully executed
    is expected to have output: "Commands:\n  hello_thor hello           # hello\n  hello_thor help [COMMAND]  # Describe available commands or one specific command\n  hello_thor version         # version\n"

Finished in 1.07 seconds (files took 0.08791 seconds to load)
8 examples, 0 failures
```

テストが無事通っている．

- Arubaはclassを叩いていない.
- learnerを直接叩く.
- コマンドラインにあるものをそのまま叩ける.


# 参考資料

- [Day 8 :Thor and Aruba]('https://qiita.com/daddygongon/private/db15283b51d4388051f2')














