xmkmcs - マルチコア対応クロスプラットフォームMACS data builder 2023.06.18

- 1つのbash script, 2つのpython script, 1つのhuman batchから成るMACS data builder
- なるべく自動化し、かつなるべくエミュ外でやれることは外でやる方針
- x68kエミュで実行するのは最後のスケジュールファイルのアセンブル、リンク、makemcsのみ
- M1 Mac (2020)だと90秒の動画を5分弱で生成
- 256x256x256(raw,lze), 384x256x256(raw,lze)の4つのモードのみサポート
- xdev68k環境相当のセットアップを行った上でいくつか追加も必要
- 詳細はbash scriptの中のコメント
- 転載不可 無保証 実験レベル