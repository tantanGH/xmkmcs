# xmkmcs

クロスプラットフォーム対応 MACS アニメーションデータ作成システム

---

## About This

macOS, Linux, WSL2(Windows) など、UNIX-Like OS上でMACSデータを作成するためのテンプレートbashスクリプト+支援ツール群のセットです。
ゼロからMACSをオーサリングするためのものではなく、素材となる何らかの動画ファイルをMACSデータに変換することを目的としています。

- 入力として任意の動画ファイル(avi,mp4等)に対応
- 解像度・fps変換により出力データサイズをコントロール可能
- アセンブル・リンク処理を行わず、素材オブジェクトから直接MCSファイルを生成
-	3通りのパレット最適化対応(完全可変、完全固定、一部固定)
-	2通りの画像圧縮対応(無圧縮、LZE圧縮)
- PCM/ADPCMデータのボリューム調整可能、レベルチェック機能付

NOTE: version 2023.10.22 よりX68エミュレータを使う必要が無くなりました。

<img src='images/xmkmcs4.png' width='800'/>

---

## 動作環境

#### ホストOS側

- macOS
- Linux

WSL2でも動作するとは思いますが、未確認です。

クロスコンパイル環境xdev68kを入れる必要はありませんが、xdev68kが入っていると楽にセットアップできます。

---

## Install (ホストOS側)

Python3環境およびpip, gitが使える状態にあること。

#### pcm2adpcm の導入

        pip install git+https://github.com/tantanGH/pcm2adpcm.git

コマンドラインから使えることを確認。

        pcm2adpcm -h


#### gif2tx の導入

        pip install git+https://github.com/tantanGH/gif2tx.git

コマンドラインから使えることを確認。

        gif2tx -h


#### pymcslk の導入

        pip install git+https://github.com/tantanGH/pymcslk.git

コマンドラインから使えることを確認。

        pymcslk -h


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

---

## 使い方

1. 素材となる動画ファイルを用意する

2. ホストOS上に作業フォルダを作成する

3. 作業フォルダに以下の2つのファイルをコピーする

- xmkmcs.sh
- schedule.s

4. xmkmcs.sh の編集

スクリプト先頭にある設定パラメータを調整していく。

        #
        #  source movie file
        #
        source_file="./xxxxx.mp4"

入力となる動画データファイルのパス名を指定する。


        #
        #  source movie cut start/to timestamps
        #    note: ffmpeg cuts movie at each key frame, so you should set 'rough' time range for these parameters.
        #
        source_cut_ss="-ss 00:00:00.000"
        source_cut_to="-to 00:03:50.000"

元動画をどの位置から切り出すかを大雑把に指定する。切り出し開始時間および切り出し終了時間をmsecまでの単位で設定。
実際にはキーフレーム単位での切り出しとなるので厳密にこのタイミングで切り出されるわけではない。


        #
        #  source movie cut start offset and length
        #    note: this is applied AFTER the source movie is cut at key frames.
        #
        source_cut_offset="-ss 00:00:00.000"
        source_cut_length="-t  00:03:44.000"

大雑把に切り出された後に厳密に切り出しを開始するオフセット位置をmsec単位で指定する。また、切り出しの長さを同様に指定する。
元動画の一部を切り出す場合は何度か微調整が必要かも。


        #
        #  FPS generic
        #
        fps=24.0        # SET_FPS24
        #fps=23.976     # SET_FPS24_NTSC
        #fps=29.97      # SET_FPS30_NTSC

        #
        #  FPS for 256 mode (vsync 55.458Hz)
        #
        #fps=13.865     # SET_FPS15_X68
        #fps=18.486     # SET_FPS20_X68
        #fps=22.183     # SET_FPS 22.183 (24fps)
        #fps=27.729     # SET_FPS30_X68

        #
        #  FPS for 384 mode (vsync 56.272Hz)
        #
        #fps=14.068     # SET_FPS 14068 (15fps)
        #fps=18.757     # SET_FPS 18757 (20fps)
        #fps=22.509     # SET_FPS 22183 (24fps)
        #fps=28.136     # SET_FPS 28136 (30fps)

生成するMACSデータのfpsを指定する。いずれかをコメントアウトする。


        #
        #  use variable palette (1) or fixed palette (0)
        #
        #variable_palette=0
        variable_palette=1

可変パレット(フレーム1枚ごとに256色パレットを新たに定義しなおす)の場合は1、固定パレット(切り出した動画全体を通して256色パレットを固定する)場合は0を指定する。基本的には1を選択し、画面全体があまり動かないもの、ゲーム動画素材などは0が良い場合が多い。また後述する機能を使って特定フレーム間のみ固定とすることも可能。この場合は1を選択しておく。


        #
        #  screen size (384x256 or 256x256)
        #
        screen_width=384
        #screen_width=256
        screen_height=256

画面モードを選択する。現時点でサポートされているのは384x256または256x256のみ。screen_widthはどちらかをコメントアウトする。


        #
        #  view size (must be within the screen size)
        #
        view_width=384
        #view_width=256
        view_height=200

実際に表示を行うサイズを指定する。横は一つ前の画面モードに合わせる。縦は4:3ソースなら256、16:9ソースであれば200を基本とするが、必要に応じて調整する。


        #
        #  LZE compression (0:no 1:yes)
        #
        lze_compression=0
        #lze_compression=1

画像圧縮方式を2通りから選ぶ。0だと無圧縮、1だと全フレームLZE圧縮。


        #
        #  dither options (0-5, 0:more grains 5:more bands)
        #
        bayer_scale=4
        #bayer_scale=5

減色時のディザのかけ具合を決める。数値が小さいほどグレインが目立つようになる。推奨値は4だが、実際の絵を見て調整していく。
5にするとほぼディザなしとなる。バンディングが目立つようになるが、ゲーム素材などはこちらの方が良い場合が多い。


        #
        #  16bit PCM frequency (48000/44100/22050)
        #
        pcm_freq=48000
        #pcm_freq=44100
        #pcm_freq=22050

出力する16bitPCMのサンプリング周波数を48kHz, 44.1kHz, 22.05kHzの中から選択する。


        #
        #  ADPCM frequency (15625)
        #
        adpcm_freq=15625

出力するADPCMの周波数を指定する。変更の必要なし。


        #
        #  PCM volume
        #
        pcm_volume=1.0

出力するPCMのボリュームをソースに対する比率で指定する。あまり大きくするとレベルオーバーになるので注意。
ADPCMデータ生成時に平均レベル・ピークレベルの簡易チェックを行い、推奨レンジに入っていない場合はエラーとなり処理が中断する。


5. xmkmcs.sh の実行

すべてのパラメータの設定が終わったらxmkmcs.shを実行する。

        ./xmkmcs.sh

PCMのレベルが範囲外の場合は処理が停止するので pcm_volume のパラメータを調整して再実行する。
その他の要因で停止した場合はエラーメッセージ参照。

最後まで処理が完了すると最終フレーム番号がメッセージ出力される。


6. schedule.s の編集

schedule.s を編集する。文字コードがSJIS(cp932)であることに注意。
HAS060でアセンブルできる形式そのままであるが実際にアセンブルは行わない。
テンプレートのschedule.sに入っていないMACSのコマンドは利用できない。

        .include macs_sch.h

        SET_OFFSET

変更不要。


        ;
        ;  16bit PCM format
        ;
        USE_DUALPCM 'S48'
        ;USE_DUALPCM 'S44'
        ;USE_DUALPCM 'S22'		

16bitPCMの出力周波数を指定する。xmkmcs.sh の設定と合わせること。


        ;
        ;  title
        ;
        TITLE   'xxxxxxxxx'

        ;
        ;  comment
        ;
        COMMENT '384x200 256色 24.0fps raw'

タイトルとコメントを設定する。SJIS(cp932)であることに注意。


        ;
        ;  screen mode
        ;
        SCREEN_ON_G384
        ;SCREEN_ON_G256

画面モード(横384 256色 または 横256 256色)を設定する。xmkmcs.sh の設定と合わせること。
G64Kモード及びその他のモードはサポートしていない。

        ;
        ;  FPS generic
        ;
        SET_FPS24	; 24.000
        ;SET_FPS24_NTSC	; 23.976
        ;SET_FPS30_NTSC	; 29.970

        ;
        ;  FPS for 256 mode (vsync 55.458Hz)
        ;
        ;SET_FPS15_X68  ; 15fps (13.865)
        ;SET_FPS20_X68  ; 20fps (18.486)
        ;SET_FPS 22183  ; 24fps (22.183)
        ;SET_FPS30_X68  ; 30fps (27.729)

        ;
        ;  FPS for 384 mode (vsync 56.272Hz)
        ;
        ;SET_FPS 14068  ; 15fps (14.068)
        ;SET_FPS 18757  ; 20fps (18.757)
        ;SET_FPS 22509  ; 24fps (22.509)
        ;SET_FPS 28136  ; 30fps (28.136)

fpsを設定する。xmkmcs.sh の設定と合わせること。


        ;
        ;  view area size
        ;
        ;SET_VIEWAREA_Y 256
        SET_VIEWAREA_Y 200

有効表示縦ライン数を指定する。xmkmcs.sh の設定と合わせること。


        ;
        ;  draw 1st frame
        ;
        DRAW_DATA_RP 10000

変更の必要なし。


        ;
        ;  start PCM playback
        ;
        PCM_PLAY_S48 pcmdat,pcmend-pcmdat
        ;PCM_PLAY_S44 pcmdat,pcmend-pcmdat
        ;PCM_PLAY_S42 pcmdat,pcmend-pcmdat
        PCM_PLAY_SUBADPCM adpcmdat,adpcmend-adpcmdat

16bitPCM再生周波数に応じて設定する。


        ;
        ;  draw frames
        ;
        DRAW_DATA 10001,19999

DRAW_DATA の第2引数は、xmkmcs.sh の最後に出力された最終フレームNo.を設定する。


        ;
        ;  finish and exit
        ;
        WAIT 60
        PCM_STOP
        EXIT

変更の必要なし。

7. pymcslk の実行

画像無圧縮の場合 (lze_compression=0設定) 

        pymcslk schedule.s (出力MCSファイル名).MCS

LZE圧縮の場合 (lze_compression=1設定)

        pymcslk --lze schedule.s (出力MCSファイル名).MCS

ホストマシンの性能にもよるが、数秒でMCSファイルが生成される。
xmkmcs.sh で lze_compression=1 を設定していても --lze オプションを指定しないと無圧縮MCSとなるので注意。

<img src='images/xmkmcs4.png' width='800'/>

以上。

---

## 一部固定パレットの指定方法

完全可変パレットにした時画面のチラつきが気になる場合は、シーン単位でパレットを固定することが可能。
この際に固定開始フレーム番号と固定終了フレーム番号を xmkmcs.sh の中で以下のようにstage2とstage3の間で指定する。


        # STAGE2 gif2tx
        stage2

        # STAGE2a (optional for fixed palette)
        fix_palette  808 1048
        fix_palette 1784 1954

        # STAGE3 lze
        stage3

フレーム番号を画面サムネイルを見ながら指定していくには、一度 xmkmcs.sh を実行した後に、付属の xmkview.x を68エミュレータ上で作業ディレクトリで実行すると比較的簡単に可能。

<img src='images/xmkmcs5.png' width='800px'/>

`S`キーで範囲先頭フレーム設定、`E`キーで範囲終端フレーム設定、`ENTER`キーでフレーム範囲をリストに追加、`SHIFT+S`でリスト書き出し、`ESC`で終了。

---

## 変更履歴

- version 2023.10.22
  - run68/HAS060/HLK を使わずにビルドできるようになり、384MBを超えるMACSデータを高速に作成可能となった

- version 2023.07.19
  - ドキュメント更新
  - PCMレベルチェック実装

- version 2023.07.12
  - XEiJ 0.23.07.11 を前提としたことで 192MB超の MACSデータが作成可能となった
  - HLK Evo 3.01+18 を前提としたことで makemcs.x が不要になった
  - 一部固定パレットのフレーム番号切り出しのためのツール(xmkview.x)を同梱

- version 2023.06.21
  - 100%raw, 100%lze, raw:lze=50:50の選択ができるようにした
  - 完全固定パレット、完全可変パレット、一部固定パレットの選択ができるようにした

- version 2023.06.18
  - 初版