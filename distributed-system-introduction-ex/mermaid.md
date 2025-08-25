# Mermaid Diagram

# 3 Node Distributed System
graph TD
    A[Node1] --- B[Node2]
    B --- C[Node3]
    C --- A


# Example Increament
sequenceDiagram
    participant Node1
    participant Node2
    participant Node3

    %% Initial state
    Node1->>Node1: Counter = 0
    Node2->>Node2: Counter = 0
    Node3->>Node3: Counter = 0

    %% Node1 increments
    Node1->>Node1: Counter = Counter + 1
    Node1->>Node2: Sync delta
    Node1->>Node3: Sync delta

    %% Node2 increments
    Node2->>Node2: Counter = Counter + 1
    Node2->>Node1: Sync delta
    Node2->>Node3: Sync delta

    %% Node3 increments
    Node3->>Node3: Counter = Counter + 1
    Node3->>Node1: Sync delta
    Node3->>Node2: Sync delta

    %% Final state after all syncs
    Node1->>Node1: Counter = 3
    Node2->>Node2: Counter = 3
    Node3->>Node3: Counter = 3

# Node 3 Offline then Online
sequenceDiagram
    participant Node1
    participant Node2
    participant Node3

    %% Initial state
    Node1->>Node1: Counter = 0
    Node2->>Node2: Counter = 0
    Node3->>Node3: Counter = 0 (offline)

    %% Node1 increments
    Node1->>Node1: Counter = Counter + 1

    %% Sync delta to Node2 only
    Node1->>Node2: Sync delta
    Node2->>Node2: Counter = 1

    %% Node3 comes online and syncs with Node1 or Node2
    Node3-->>Node1: Request latest delta
    Node1->>Node3: Send delta
    Node3->>Node3: Counter = 1

    %% Final state
    Node1->>Node1: Counter = 1
    Node2->>Node2: Counter = 1
    Node3->>Node3: Counter = 1
