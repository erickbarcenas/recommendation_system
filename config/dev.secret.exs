config :bolt_sips, Bolt,
  url: "bolt://e<*****>.databases.neo4j.io",
  basic_auth: [username: "neo4j", password: "a--<*******>"],
  pool_size: 10,
  ssl: true,
  max_overflow: 2,
  queue_interval: 500,
  queue_target: 1500,
  prefix: :default