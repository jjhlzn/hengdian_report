FROM clickmechanic/ci-environment

RUN uname -r

#RUN sudo apt-get update && apt-get install -y curl apt-transport-https && \
 # curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  #echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#RUN sudo apt-get update && apt-get install -y \
  #wget \
  #libc6-dev \
  #curl \
  #freetds-dev \
  #sqsh \
  #freetds-bin \
  #freetds-common \
  #git \
  #ghostscript \
  #libaio1 \
  #odbcinst \
 # postgresql-contrib \
 # tdsodbc \
 # unixodbc \
 # unzip \
#  build-essential \
 # libpq-dev \
 # nodejs \
 # ruby \
 # ruby-dev \
 # tzdata \
  #yarn \
 # zlib1g-dev \
 # git \
 # libsqlite3-dev 
  #apt-utils




# Replace original freetds.conf with our's, so we can update mssql server ip.
#COPY files/mssql/freetds.conf /etc/freetds/freetds.conf

WORKDIR /app



RUN gem install bundler
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app