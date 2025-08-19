import Config
# use current node1@current-hostname
# ex. node1@my-hostname
config :libcluster,
  topologies: [
    local_epmd: [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: [
          :"node1@pppammpz",
          :"node2@pppammpz",
          :"node3@pppammpz"
        ]
      ]
    ]
  ]
