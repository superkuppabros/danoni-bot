# danoni-bot
ダンおにプレイイベント用のDiscord botです。

## コマンド一覧
- `chance`: チャンスカードを引く
- `random`: ランセレを引く
- `/initialize {password}`: DBの初期化
- `/join {name}`: 参加者の追加
- `/delete {name}`: 参加者の削除
- `/divide {password}`: チーム分け
- `/show_members`: 参加者確認
- `/game {league} {winner} {loser}`: ゲームの登録
- `/result {league}`: 結果の確認
- `/next_game {league} {pair} {match name}`: 次試合の組分け
  - pair: 数字を入れる、1234なら1-2, 3-4の試合

## その他動作
- CW Editionの1行リザルトに対して情報のまとめ表示
- ユーザ各自での参加

## 環境
- Ruby 2.7.1
- MySQL 5.7.31

## 起動手順
1. botのアカウント作成、設定
    - https://discord.com/developers/applications
1. MySQLにユーザ`danoni-bot`、データベース`danoni`を追加
1. インストール
    ```
    $ bundle install --path vendor/bundle
    ```
1. 環境変数の設定
    ```
    $ export DANONI_BOT_PASSWORD={your_password}
    $ export DANONI_BOT_TOKEN={discord_bot_token}
    ```
1. 起動
    ```
    $ bundle exec ruby main.rb
    ```
