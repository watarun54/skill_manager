# README

* dependencies

```
ruby 2.5.0
Rails 5.2.3
Boostrap4
mysql 
```

* gem

```
dotenv-rails: .envにある環境変数を使用するため
chartkick, chartable: グラフを簡単に描画するため
```

* How to start

```
bundle install
```
set .env file
```
rails db:create
rails db:migrate
sudo mysql.server restart
rails s
```
