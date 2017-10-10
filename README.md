# Acceptto OpenID Connect Showcase Demo

  This repo contains a demo application that showcases Acceptto's OpenID Connect authentication feature.

### Installation

To install you need the following:

- [Ruby](https://www.ruby-lang.org/en/) 2.4.x
- [PostgreSQL](https://www.postgresql.org/)
- [Ruby on Rails](http://guides.rubyonrails.org/index.html) 5.1

Clone the latest version of the repository

- [Repository](https://github.com/chris-clifford/open-id-showcase)

### Configuration

Enter the Configuration setting in the following file:

  - config/url_parameters.yml

  ```
  production:
    base_url: [Enter production Accepto server url e.g. acceptto.com]
    client_id: [Enter client id for production]
    client_secret: Enter client secret for production]
    redirect_url: [Enter production base url of the this application]
    public_key: [Enter public key for production]
  development:
    base_url: [Enter development Accepto server url e.g. acceptto.com]
    client_id: [Enter client id for development]
    client_secret: Enter client secret for development]
    redirect_url: [Enter development base url of the this application]
    public_key: [Enter public key for development]
  ```

### Setup

1. Start the postgresql server:

  ```bash
  $ postgres
  ```

2. Install gems, in the repo directory:

  ```bash
  $ bundle install
  ```

3. Create the database:

  ```bash
  $ rails db:create
  ```

4. Setup the database:

  ```bash
  $ rails db:setup
  ```

5. Run the start server script:

  ```bash
  $ rails serve
  ```

### Running the Application

Launch your browser and navigate to localhost:3000
