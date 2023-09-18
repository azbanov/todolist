up:
	docker compose up -d

start:
	make up
	iex -S mix phx.server

stop:
	docker compose stop

down: 
	docker compose down

restart:
	make stop
	make start
