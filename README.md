# 「スクリプト言語の作り方」をRubyに移植するプロジェクト

[ここ](http://gihyo.jp/book/2012/978-4-7741-4974-5) で紹介されている「2週間でできる！ スクリプト言語の作り方」の内容をRubyで実装する試み。（というかお勉強）  
スクリプト言語でスクリプト言語をつくるっていうなんとも不思議なプロジェクトです。  
あまり実用性はありません。

ちなみにコードは3人で書いてます。

## 言語仕様
### なにができるの
- 四則演算ができます
- 変数がつかえます
- while文がつかえます
- if-else文もつかえます
- 不等号、各種記号もつかえます（一部未対応）

### まだできないこと
- 関数がつくれません
- 配列もつかえません
- ぶっちゃけただの計算機です

### 文法規則
- under construction..


## 実行方法
- cloneする（もしくはforkしてからcloneでも）  
  `$ git clone git@github.com:username/stone.git`
- stoneディレクトリへ移動する  
  `$ cd stone`
- 実行する  
  `$ ruby bin/eval-stone sample/sample.stone`

実行の際の2つ目の引数は、stone言語のプログラムが記述されたファイル。実行ファイルに引数としてファイルのパスを渡すことで、とりあえず実行するようにしている。

繰り返すが、実用性は（たぶん）ない。

## 今後の展開
- とりあえず関数
- 次に配列
- その次は真面目路線か、ネタ方向に走るかどうかで決まります。
