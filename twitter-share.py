# In order to run this program, go to dev.twitter.com and create a consumer_key and a consumer_secret
# Then run the program and copy down the access toekn into the code
# DO NOT COMMIT CODE WITH KEY/SECRET SPECIFIED.

import tweepy
import csv

players_list = []
with open('nba.csv', newline='') as csvfile:
	players = csv.reader(csvfile, delimiter=',', quotechar='|')
	for player in players:
		players_list.append(player[2].lstrip('@'))

# consumer_key = specify_your_consumer_key
# consumer_secret = specify_your_consumer_secret

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)

# access_token = specify_your_access_token
# access_token_secret = specify_your_token_secret

if access_token is None or access_token_secret is None:
	# Get request request token
	try:
	    redirect_url = auth.get_authorization_url()
	except tweepy.TweepError:
	    print('Error! Failed to get request token.')

	# Redirect user to twitter.com to authorize our application
	print(redirect_url)
	verifier = input('Verifier:')

	# Exchange the authorized request token for an access token.
	try:
	    auth.get_access_token(verifier)
	    print("After getting access token, insert into file so that you don't have to re-authorize")
	    print(auth.access_token)
	    print(auth.access_token_secret)
	except tweepy.TweepError:
	    print('Error! Failed to get access token.')

	access_token = auth.access_token
	access_token_secret = auth.access_token_secret

auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth, wait_on_rate_limit=True)

players_dict = {}
for player in players_list:

	try:
		user = api.get_user(player)
		players_dict[player] = user.followers_count
		print(player + ", " + str(user.followers_count) + "\n")
	except: 
		print(player + ", 0000\n")

# print(players_dict)