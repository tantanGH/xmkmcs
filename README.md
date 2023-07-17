# xmkmcs

クロスプラットフォーム対応 MACS アニメーションデータ作成ツール

---

## About This

- macOS, Linux, WSL2(Windows) などの UNIX like環境でMACSデータを作成
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

