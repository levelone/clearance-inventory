# Basic Setup

When in project directory run the following:

```
bundle install && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed
```

Once complete, run server and start importing `example.csv` file:

```
bundle exec rails s -p 3001
```

# Tech Specs

- Rails 4.2
- Ruby 2.2
- SQLite

# Screenshot

![alt text](https://raw.githubusercontent.com/levelone/clearance-inventory/master/public/images/inventory-management.png)
