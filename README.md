# README

## Premise

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.

## Documentation

List of Endpoints

`GET    /users/:user_id/feed(.:format)`
Displays sleep sessions of users that `user_id` follows `from` a certain time. 

params:
  - `user_id` - ID of user
  - `from` - Date filter. It will default to a value of the beginning of 7 days ago if left nil


`POST   /users/:user_id/clock_in(.:format)`
Creates a new sleep session for `user_id`

params:
  - `user_id` - ID of user
    

`POST   /users/:followed_id/follow(.:format)`
Follow another user

params:
  - `followed_id` - ID of user to be followed
  - `follower_id` - ID of user doing the following

`DELETE /users/:followed_id/unfollow(.:format)`
Unfollow a user

params:
  - `followed_id` - ID of user to be unfollowed
