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

CLIなので、コマンドラインのみの操作となります。

---

## Install (ホストOS側)

xdev68k クロスコンパイル環境が既に導入されていれば、手順1,2はスキップしてok。

1. [run68mac](https://github.com/GOROman/run68mac) を導入する。(オリジナルのrun68をWindows専用ではなく、macsOS, Linux, WSL2などでも動作するるようにしたもの)

2. [HAS060.X](http://retropc.net/x68000/software/develop/as/has060/) をダウンロードし、アクセス可能な位置に置いておく。

        /opt/xdev68k/x68k_bin/HAS060.X

3. run68 で HAS060 が使えることを確認。

        $ run68 /opt/xdev68k/x68k_bin/HAS060.X
        X68k High-speed Assembler v3.09+91 (C) 1990-1994/1996-2023 Y.Nakamura/M.Kamada
        使用法: has060 [スイッチ] ファイル名
                -1              絶対ロング→PC間接(-b1と-eを伴う)
                -8              シンボルの識別長を8バイトにする
        ...

4. Pythonツール `pcm2adpcm` を導入。

        pip install git+https://github.com/tantanGH/pcm2adpcm.git

コマンドラインで使えることを確認。

        pcm2adpcm -h

5. Pythonツール `gif2tx` を導入。

        pip install git+https://github.com/tantanGH/gif2tx.git

コマンドラインから使えることを確認。

        gif2tx -h

6. dos2unix を導入。

macOS:

        brew install dos2unix

Linux/WSL2:

        sudo apt-get install dos2unix

コマンドラインで `unix2dos` が使えることを確認。

        unix2dos -h

7. [lze](http://gorry.haun.org/pw/?lze) を導入。

Makefileを変更してソースからコンパイルしインストールする。gccでのMakefile例は lze/Makefile を参照。

コマンドラインで `lze` が使えることを確認。

        lze -h

6. [ffmpeg](https://ffmpeg.org/) を導入。

macOS:

        brew install ffmpeg

Linux/WSL2:

        sudo apt-get install ffmpeg

コマンドラインで `ffmpeg` が使えることを確認。

        ffmpeg -h

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