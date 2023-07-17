# xmkmcs

クロスプラットフォーム対応 MACS アニメーションデータ作成ツール

---

## About This

- macOS, Linux, WSL2(Windows) などでMACSデータを作成するためのテンプレートbashスクリプト
- 時間のかかるTx/Tpオブジェクトアセンブル処理をマルチコアで並列実行
- 90秒のMACSを4分程度で生成(M1 MacBook)
-	3通りのパレット最適化対応(完全可変、完全固定、一部固定)
-	3通りの画像圧縮対応(無圧縮、LZE圧縮、無圧縮:LZE=50:50)
-	PCM/ADPCMデータをエミュ外で自動生成、ボリューム調整可
-	MACS向けの任意のfpsを指定可能によりデータサイズを最適化

注意: 最後のスケジュールアセンブルおよびリンク部分のみ68エミュレータ上での実行が必要です。

注意: ゼロからMACSをオーサリングするためのものではなく、素材となる何らかの動画ファイルをMACSに変換するものです。

---

## 動作環境

- macOS
- Linux
- WSL2 (未確認)

UNIX-Like OSが対象です。CLIなので、コマンドラインのみの操作となります。

---

## Install (ホストOS側)

#### Pythonツール `pcm2adpcm` の導入

        pip install git+https://github.com/tantanGH/pcm2adpcm.git

コマンドラインから使えることを確認。

        pcm2adpcm -h

#### Pythonツール `gif2tx` の導入

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

コマンドラインで `ffmpeg` が使えることを確認。

        ffmpeg -h

7. [run68mac](https://github.com/GOROman/run68mac) を導入する。(オリジナルのrun68をWindows専用ではなく、macsOS, Linux, WSL2などでも動作するるようにしたもの) xdev68k クロスコンパイル環境が既に導入されていればスキップ。

8. [HAS060.X](http://retropc.net/x68000/software/develop/as/has060/) をダウンロードし、アクセス可能な位置に置いておく。xdev68k クロスコンパイル環境が既に導入されていればスキップ。

例：
        /opt/xdev68k/x68k_bin/HAS060.X

9. run68 で HAS060 が使えることを確認。

        $ run68 /opt/xdev68k/x68k_bin/HAS060.X
        X68k High-speed Assembler v3.09+91 (C) 1990-1994/1996-2023 Y.Nakamura/M.Kamada
        使用法: has060 [スイッチ] ファイル名
                -1              絶対ロング→PC間接(-b1と-eを伴う)
                -8              シンボルの識別長を8バイトにする
        ...

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