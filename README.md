# Skill Manager

スキルの視覚化により、  
・自分自身のスキルの客観的理解  
・マネジメント担当者が個々のスキルを把握する手助け  
を目的として開発中

![image](https://github.com/watarun54/skill_manager/assets/37992018/d9aa83e0-f6b6-43ff-b631-f7419093cc72)


* Dependencies/Technologies

```
ruby 2.5.0
Rails 5.2.3
jQuery
Bootstrap4
mysql 
redis
さくらVPS
```

* Gem

```
dotenv-rails # .envにある環境変数を使用するため
chartkick, chartable # グラフを簡単に描画するため
chartjs-ror # レーダーチャートを描画するため（chartkickはレーダーチャートをサポートしていない）
line-bot-api
sidekiq
kaminari
```

* Application/Web server

```
puma/nginx
```

## さくらVPS

* Start in local env

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
* Update production env in ubuntu16.04

```
git pull origin [branch]
sudo /etc/init.d/puma restart
* if there is any change in migration files
* rails db:migrate
```

* Run redis and sidekiq to enable job in ubuntu16.04

```
bundle install # gem 'sidekiq'
sudo apt-get update
sudo apt-get install redis-server
sudo service redis start
bundle exec sidekiq --daemon --environment=[env] --logfile [log_file_path]
```
Check whether they are working
```
ps ax | grep redis
ps ax | grep sidekiq
```
[[Ruby on Rails]Active Job – Sidekiqを使ってのJobの実行](https://dev.classmethod.jp/server-side/ruby-on-rails/ruby-on-rails_active-job-sidekiq/)

[[Rails] RedisとSidekiqとActiveJobで苦しむ](https://t-kojima.github.io/2018/05/10/0001-redis-sidekiq-activejob/)

[非同期実行 Sidekiqの導入 Mac Ubuntu](https://qiita.com/ayies128/items/add88acef58280ef4b13)

## 環境構築 with Docker

```
$ cp .env.sample .env
$ docker-compose build
$ docker-compose up -d
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate
```
