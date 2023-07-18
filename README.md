# xmkmcs

クロスプラットフォーム対応 MACS アニメーションデータ作成システム

---

## About This

macOS, Linux, WSL2(Windows) など、UNIX-Like OS上でMACSデータを作成するためのテンプレートbashスクリプト+支援ツール群のセットです。
ゼロからMACSをオーサリングするためのものではなく、素材となる何らかの動画ファイルをMACSデータに変換することを目的としています。

- 入力として任意の動画ファイル(avi,mp4等)に対応
- 解像度・fps変換により出力データサイズをコントロール可能
- 時間のかかるTx/Tpオブジェクトアセンブル処理をマルチコアで並列実行
-	3通りのパレット最適化対応(完全可変、完全固定、一部固定)
-	3通りの画像圧縮対応(無圧縮、LZE圧縮、無圧縮:LZE=50:50)
- PCM/ADPCMデータのボリューム調整可能、レベルチェック機能付

注意: 最後のスケジュールアセンブルおよびリンク部分のみ68エミュレータ上での実行が必要です。(推奨：XEiJ 060turbo ハイメモリ拡張モード)

手元の環境(M1 MacBook)だと、約4分ほどで90秒のMACSデータの生成が可能です。

---

## 動作環境

#### ホストOS側

- macOS
- Linux

WSL2でも動作するとは思いますが、環境を持っていないため未確認です。

クロスコンパイル環境xdev68kを入れる必要はありませんが、xdev68kが入っていると楽にセットアップできます。

#### 68エミュレータ側

- XEiJ 0.23.07.12以上 ハイメモリ 768MB 060turbo.sys 0.58以上 拡張モード(`-ss` `-dv` `-xm`)

最終的にMACSデータを出力するにはHLKによるリンク処理が必要であり、この際に出力MACSデータサイズの約2倍のメモリを必要とします。
ハイメモリ768MBの環境であれば約384MBまでのMACSデータを生成することが可能です。

---

## Install (ホストOS側)

#### pcm2adpcm の導入

        pip install git+https://github.com/tantanGH/pcm2adpcm.git

コマンドラインから使えることを確認。

        pcm2adpcm -h


#### gif2tx の導入

        pip install git+https://github.com/tantanGH/gif2tx.git

コマンドラインから使えることを確認。

        gif2tx -h


#### dos2unix の導入

macOS:

        brew install dos2unix

Linux/WSL2:

        sudo apt-get install dos2unix

コマンドラインで `unix2dos` が使えることを確認。

        unix2dos -h


#### lha の導入

macOS:

        brew install lha

Linux/WSL2:

        sudo apt-get install lhasa

コマンドラインで `lha` が使えることを確認。

        lha


#### lze の導入

* [lze](http://gorry.haun.org/pw/?lze)

作業ディレクトリにて、

        wget --output-document=lze_20080228a.lzh 'http://gorry.haun.org/cgitest/download.pl?subject=CGI-DOWNLOAD%20lze_20080228a.lzh&info=readcount&file=lze.html&downfile=lze_20080228a.lzh'

        lha x lze_20080228a.lzh

ソースファイル末尾にある^Zを削除する。

        mv lze.c lze.c.orig

        sed -e '$d' lze.c.orig > lze.c

本リポジトリの`lze/Makefile.gcc`を使ってmakeする。

        make -f Makefile.gcc

パスの通った場所に出来上がった`lze`をコピーするかシンボリックリンクを張っておく。

コマンドラインで `lze` が使えることを確認。

        lze

#### ffmpeg の導入

* [ffmpeg](https://ffmpeg.org/)

macOS:

        brew install ffmpeg

Linux/WSL2:

        sudo apt-get install ffmpeg

他のツールに比べると規模が大きいので注意。ラズパイOSの場合バージョンによってはエラーになるかも。

コマンドラインで `ffmpeg` が使えることを確認。

        ffmpeg -h

#### run68mac の導入

* [run68mac](https://github.com/GOROman/run68mac) 

オリジナルのrun68.exeと異なり、Windows専用ではなく、macsOS, Linux, WSL2などでも動作するるようにしたもの。
リンク先の手順に従い導入する。xdev68k クロスコンパイル環境が既に導入されていれば確認のみで良い。

コマンドラインで `run68` が使えることを確認。

        run68


#### HAS060.X の導入

* [HAS060](http://retropc.net/x68000/software/develop/as/has060/) 

HAS060.X をアクセス可能な位置に置いておく。xdev68k クロスコンパイル環境が既に導入されていれば確認のみで良い。

例：
        /opt/xdev68k/x68k_bin/HAS060.X

run68で HAS060.X が使えることを確認。

        $ run68 /opt/xdev68k/x68k_bin/HAS060.X
        X68k High-speed Assembler v3.09+91 (C) 1990-1994/1996-2023 Y.Nakamura/M.Kamada
        使用法: has060 [スイッチ] ファイル名
                -1              絶対ロング→PC間接(-b1と-eを伴う)
                -8              シンボルの識別長を8バイトにする
        ...

---

## Install (68エミュレータ側)

#### XEiJ 0.23.07.12テスト版以上の導入

* [XEiJテスト版](https://stdkmd.net/xeijtest/)

- ハイメモリ 768MB 設定
- 機種選択 060turbo 50MHz
- 同梱されている 060turbo.sys 0.58 を拡張モード(`-ss` `-dv` `-xm`)で組み込む
- HFSでホストOS側のフォルダが見えるようにしておく


#### HAS060.X 3.09+91以上の導入

* [HAS060](http://retropc.net/x68000/software/develop/as/has060/)


#### HLK evolution 3.01+18以上の導入

* [HLK evolution](https://github.com/kg68k/hlk-ev)

3.01+18で対応したMACSファイルダイレクト生成オプションを前提としているので、必ずこのバージョン以上を導入する。


#### 060highの導入

* [060high](http://retropc.net/x68000/software/hardware/060turbo/060high/)

HLK evolutionがハイメモリを使うために必要


#### MACSスケジューラ用インクルードファイルの導入

最新のMACSDRV(改造版)に含まれる `macs_sch.h` を環境変数`include`(小文字)で指定したディレクトリにコピーしておく。
環境変数`HAS`で`-i<ディレクトリ名>`と指定した場所でも良い。

---

## 使い方

1. ホストOS上に作業フォルダを作成する

2. 素材となる動画ファイルを用意する

3. 作業フォルダに以下の3つのファイルをコピーする

- xmkmcs1.sh
- xmkmcs2.bat
- schedule.s

このフォルダはXEiJから読み書きアクセスできること。

4. xmkmcs1.sh の編集

スクリプト終盤にある設定パラメータを調整していく。

        # HAS060.X path
        has060=/opt/xdev68k/x68k_bin/HAS060.X 

ホストOS上に置いた HAS060.X のフルパスを設定する。

        # source movie cut start/to timestamps
        #   note: ffmpeg cuts movie at each key frame, so you should set 'rough' time range for these parameters.
        source_cut_ss="-ss 00:02:57.500"
        source_cut_to="-to 00:04:29.000"

元動画をどの位置から切り出すかを大雑把に指定する。切り出し開始時間および切り出し終了時間をmsecまでの単位で設定。
実際にはキーフレーム単位での切り出しとなるので厳密にこのタイミングで切り出されるわけではない。

        # source movie cut start offset and length
        #   note: this is applied AFTER the source movie is cut at key frames.
        source_cut_offset="-ss 00:00:00.800"
        source_cut_length="-t  00:01:29.500"



---

## 変更履歴

version 2023.07.12
- XEiJ 0.23.07.11 を前提としたことで 192MB超の MACSデータが作成可能となった
- HLK Evo 3.01+18 を前提としたことで makemcs.x が不要になった
- 一部固定パレットのフレーム番号切り出しのためのツール(xmkview.x)を同梱

version 2023.06.21
- 100%raw, 100%lze, raw:lze=50:50の選択ができるようにした
- 完全固定パレット、完全可変パレット、一部固定パレットの選択ができるようにした
- 060high の利用をやめて、HIMEM対応版 hlk.r の利用を前提にした(128MBを超えるMACSの作成に必要)

version 2023.06.18
- 1つのbash script, 2つのpython script, 1つのhuman batchから成るMACS data builder
- なるべく自動化し、かつなるべくエミュ外でやれることは外でやる方針
- x68kエミュで実行するのは最後のスケジュールファイルのアセンブル、リンク、makemcsのみ
- マルチコアに対応し、M1 Mac (2020)だと90秒の動画を5分弱で生成
- 256x256x256(raw,lze), 384x256x256(raw,lze)の4つのモードのみサポート
- xdev68k環境相当のセットアップを行った上でいくつか追加も必要
- 詳細はbash scriptの中のコメント
- 転載不可 無保証 実験レベル