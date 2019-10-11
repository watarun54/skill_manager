# README

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
