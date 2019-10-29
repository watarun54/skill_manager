FROM ruby:2.5.0

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs

# ワーキングディレクトリの設定
RUN mkdir /myapp
ENV APP_ROOT /myapp
WORKDIR $APP_ROOT

# gemfileを追加する
ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock

# gemfileのinstall
RUN bundle install
ADD . $APP_ROOT

