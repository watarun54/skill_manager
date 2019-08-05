# README

* dependencies

```
ruby 2.5.0
Rails 5.2.3
Bootstrap4
mysql 
```

* gem

```
dotenv-rails: .envにある環境変数を使用するため
chartkick, chartable: グラフを簡単に描画するため
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
