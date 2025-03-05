# Order
[![](https://mermaid.ink/img/pako:eNrFU7FOwzAQ_RXrJirSKklbSj10KSsCqQtCkZCJr62lJA5nG1GqjvwAMxITP8YX8Ak4SVtBC0MHRCbfu_eenx3fElItETgYvHNYpHimxIxEnhTMf6Ugq1JVisKycaawsPv4BUmkiSuR7pXR9AvhknSKpu43jMauPRrt6Dkz1otvdAUfJTDTWrK6SKDVSHcU3uP4-x6cTSoPVjbAF9WW0vaqJgJn7y9PTXcjQMmMS6vV1GXZ4tDIt-KvEu-KPl6f39iYhJmzIxLKoGFIpKn1s8EV20u-7jKLlKtCWJSHnlYU2s793f3vP4IAcn8EoaR_y8vKLQEfK8cEuF9KnAqX2QSSYuWpwlk9WRQpcEsOAyDtZnPgU5EZX7lS-otYD8KGglJZTefNsNQzE4B_3tdabym-BL6EB-DRIOzE0aAbhr2oH3aH4UkACw9HndgjURz242E06J2uAnisDaLVJ5_lPik?type=png)](https://mermaid.live/edit#pako:eNrFU7FOwzAQ_RXrJirSKklbSj10KSsCqQtCkZCJr62lJA5nG1GqjvwAMxITP8YX8Ak4SVtBC0MHRCbfu_eenx3fElItETgYvHNYpHimxIxEnhTMf6Ugq1JVisKycaawsPv4BUmkiSuR7pXR9AvhknSKpu43jMauPRrt6Dkz1otvdAUfJTDTWrK6SKDVSHcU3uP4-x6cTSoPVjbAF9WW0vaqJgJn7y9PTXcjQMmMS6vV1GXZ4tDIt-KvEu-KPl6f39iYhJmzIxLKoGFIpKn1s8EV20u-7jKLlKtCWJSHnlYU2s793f3vP4IAcn8EoaR_y8vKLQEfK8cEuF9KnAqX2QSSYuWpwlk9WRQpcEsOAyDtZnPgU5EZX7lS-otYD8KGglJZTefNsNQzE4B_3tdabym-BL6EB-DRIOzE0aAbhr2oH3aH4UkACw9HndgjURz242E06J2uAnisDaLVJ5_lPik)

sequenceDiagram
    participant Client
    participant OrderSupervisor
    participant OrderProcessor

    Client->>OrderSupervisor: start_order("good order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>Client: ✅ Order processed successfully

    Client->>OrderSupervisor: start_order("bad order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>OrderProcessor: 💥 Crash (raises error)
    OrderProcessor--X OrderSupervisor: Process terminated

    Client->>OrderSupervisor: start_order("another order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>Client: ✅ Order processed successfully

# Example: Order -> Payment -> Delivery
[![](https://mermaid.ink/img/pako:eNqFUs1uwjAMfpXI54IKLSXkwGVcp6ExLlMvUepCtbZhaTKtQ7z7ErIyUTrWk2N_P7brIwiZITBo8N1gLXBV8J3iVVoT-x240oUoDrzWZNugus0-qQzVWkmBTSMH6mveVljrO4gVlsUHqvZFcfHmLDzE2Y2Wy2t9RtYlF-hdPe4aMMTw4R2OJTk35vPkQdZ5oSrMulZuLPpDMfLsttdcxvW8PmyQ2bV3nzk0l8eQjREulZvyz357K_5ttyt4Xg82RDwH_9Au6-wKZKO5Ng3ZHjKu3VohgApVxYvMHt7RqaSg91hhCsyGGebclDqFtD5ZKDdabtpaANPKYABKmt0eWM7Lxr7MWfTnai9ZzAot1aM_beF-6M4q2Xt7lbLqhOwT2BE-gdFoHC2SkM6TOIlpHNEAWmAjOp5MaRROkmkY0yha0FMAX2eBcEwXEY0X83Aym8bzJJydvgFLAiMi?type=png)](https://mermaid.live/edit#pako:eNqFUs1uwjAMfpXI54IKLSXkwGVcp6ExLlMvUepCtbZhaTKtQ7z7ErIyUTrWk2N_P7brIwiZITBo8N1gLXBV8J3iVVoT-x240oUoDrzWZNugus0-qQzVWkmBTSMH6mveVljrO4gVlsUHqvZFcfHmLDzE2Y2Wy2t9RtYlF-hdPe4aMMTw4R2OJTk35vPkQdZ5oSrMulZuLPpDMfLsttdcxvW8PmyQ2bV3nzk0l8eQjREulZvyz357K_5ttyt4Xg82RDwH_9Au6-wKZKO5Ng3ZHjKu3VohgApVxYvMHt7RqaSg91hhCsyGGebclDqFtD5ZKDdabtpaANPKYABKmt0eWM7Lxr7MWfTnai9ZzAot1aM_beF-6M4q2Xt7lbLqhOwT2BE-gdFoHC2SkM6TOIlpHNEAWmAjOp5MaRROkmkY0yha0FMAX2eBcEwXEY0X83Aym8bzJJydvgFLAiMi)

sequenceDiagram
    participant Client
    participant OrderSupervisor
    participant OrderProcessor

    Client->>OrderSupervisor: start_order("good order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>Client: ✅ Order processed successfully

    Client->>OrderSupervisor: start_order("bad order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>OrderProcessor: 💥 Crash (raises error)
    OrderProcessor--X OrderSupervisor: Process terminated

    Client->>OrderSupervisor: start_order("another order")
    OrderSupervisor->>+OrderProcessor: Start process
    OrderProcessor-->>Client: ✅ Order processed successfully


# Example: Order -> Payment -> Delivery -> Notification

sequenceDiagram
    participant Customer
    participant OrderProcessor
    participant PaymentProcessor
    participant DeliveryTracker
    participant NotificationWorker

    Customer->>OrderProcessor: Place Order
    OrderProcessor->>PaymentProcessor: Process Payment
    PaymentProcessor-->>OrderProcessor: Payment Success
    OrderProcessor->>DeliveryTracker: Dispatch Order
    DeliveryTracker-->>NotificationWorker: Notify Delivery
    NotificationWorker-->>Customer: Order Status Update


# Single node
graph TD;
    OrderSupervisor["🟢 OrderSupervisor (DynamicSupervisor)"]
    OrderProcessor1["💥 OrderProcessor(Crashed)"]

    OrderSupervisor --> OrderProcessor1

