FROM ruby:3.3-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    build-essential \
    libpq-dev \
    libyaml-dev \
    curl \
    git \
    nodejs \
    npm

# Install Yarn
RUN npm install --global yarn

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler:2.2.19

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy application code
COPY . .

# Add entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port
EXPOSE 3000

# Start server
CMD ["rails", "server", "-b", "0.0.0.0"]
