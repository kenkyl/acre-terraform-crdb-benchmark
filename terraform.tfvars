subscription_id = "ef03f41d-d2bd-4691-b3a0-3aff1c6711f7"
tenant_id = "1428732f-21cf-469e-ad48-5721f4eac1e2"
client_id = "e8121ee7-08d3-40ae-b7b1-2494b7d45a30"
client_secret = "oXLiVt-Hcly~mngNTt5S2NpygFwIXa0ADK"


########################################################################## memtier_benchmark 
  
 #-s, --server=ADDR              Server address (default: localhost)
 memtier_redis_server_address = "redis-13649.bamos-west.demo.redislabs.com"
 
 # -p, --port=PORT                Server port (default: 6379)
 memtier_redis_port =  "13649"

# first data input script into redis db.
memtier_data_input_1 = "memtier_benchmark -x 3 -n 180000 -c 1 -t 1 --ratio=1:0 --data-size=80 --key-maximum=180000 --pipeline=1000 --key-pattern=S:S --hide-histogram"

# first memtier benchmark
memtier_benchmark_1 = "memtier_benchmark -x 2 -t 8 -c 100 -n 100 --ratio=1:10000 --data-size=80 --key-maximum=180000 --hide-histogram"


### redis-cli -h redis-13649.bamos-west.demo.redislabs.com -p 13649 flushall

##### MEMTIER OPTIONS
# Connection and General Options:
#   -s, --server=ADDR              Server address (default: localhost)
#   -p, --port=PORT                Server port (default: 6379)
#   -S, --unix-socket=SOCKET       UNIX Domain socket name (default: none)
#   -P, --protocol=PROTOCOL        Protocol to use (default: redis).  Other
#                                  supported protocols are memcache_text,
#                                  memcache_binary.
#   -x, --run-count=NUMBER         Number of full-test iterations to perform
#   -D, --debug                    Print debug output
#       --client-stats=FILE        Produce per-client stats file
#       --out-file=FILE            Name of output file (default: stdout)
#       --show-config              Print detailed configuration before running

# Test Options:
#   -n, --requests=NUMBER          Number of total requests per client (default: 10000)
#   -c, --clients=NUMBER           Number of clients per thread (default: 50)
#   -t, --threads=NUMBER           Number of threads (default: 4)
#       --test-time=SECS           Number of seconds to run the test
#       --ratio=RATIO              Set:Get ratio (default: 1:10)
#       --pipeline=NUMBER          Number of concurrent pipelined requests (default: 1)
#       --reconnect-interval=NUM   Number of requests after which re-connection is performed
#       --multi-key-get=NUM        Enable multi-key get commands, up to NUM keys (default: 0)
#   -a, --authenticate=PASSWORD    Authenticate to redis using PASSWORD
#       --select-db=DB             DB number to select, when testing a redis server

# Object Options:
#   -d  --data-size=SIZE           Object data size (default: 32)
#   -R  --random-data              Indicate that data should be randomized
#       --data-size-range=RANGE    Use random-sized items in the specified range (min-max)
#       --data-size-list=LIST      Use sizes from weight list (size1:weight1,..sizeN:weightN)
#       --expiry-range=RANGE       Use random expiry values from the specified range

# Imported Data Options:
#       --data-import=FILE         Read object data from file
#       --generate-keys            Generate keys for imported objects

# Key Options:
#       --key-prefix=PREFIX        Prefix for keys (default: memtier-)
#       --key-minimum=NUMBER       Key ID minimum value (default: 0)
#       --key-maximum=NUMBER       Key ID maximum value (default: 10000000)
#       --key-pattern=PATTERN      Set:Get pattern (default: R:R)