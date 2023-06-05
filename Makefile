test.all:
	docker-compose run app bash -c "MIX_ENV=test mix test"

format:
	docker-compose run app bash -c "mix format"

dialyzer:
	docker-compose run app bash -c "mix dialyzer"
