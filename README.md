# messari_data_pull
Repository to pull data using the Messari API: https://messari.io/api/


Use this repository to do something similar to the [crypto_compare_data repository](https://github.com/ries9112/crypto_compare_data) setting up a process using GitHub actions that pulls data from the API and uploads it into the database. Write data to Octoparse since it would be in UTC. Schedule to run hourly for at least top 100 symbols (depending on how heavy making the request is).
