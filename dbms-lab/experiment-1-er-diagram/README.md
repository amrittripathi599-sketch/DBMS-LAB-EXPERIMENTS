# Experiment 1 — E-R Diagram for an Indian E-commerce Platform

**Aim:** To design an entity-relationship (E-R) diagram for an Indian e-commerce platform
by identifying the major entities and their attributes, keys, relationships and
constraints, including primary and composite keys, multi-valued attributes, weak
entities, specialization/generalization, and participation constraints.

## Entities and Attributes

### Customer
- Customer_ID (PK)
- Customer_Name
- Email (UNIQUE)
- Phone (multi-valued)
- Address

### Order
- Order_ID (PK)
- Order_Date
- Total_Amount
- Order_Status
- Customer_ID (FK)

### Bill
- Bill_No (PK)
- Bill_Date
- Bill_Amount
- Order_ID (FK)

### Payment
- Payment_ID (PK)
- Payment_Mode
- Payment_Amount
- Payment_Status
- Order_ID (FK)

### Order_Item (weak entity)
- Item_No (partial key)
- Quantity
- Unit_Price
- Order_ID (FK)
- Product_ID (FK)

### Category
- Category_ID (PK)
- Category_Name
- Description

### Seller
- Seller_ID (PK)
- Seller_Name
- Seller_Rating

### Product
- Product_ID (PK)
- Product_Name
- Price
- Stock_Quantity
- Warranty
- Category_ID, Seller_ID (FK)

## Relationship Sets and Cardinality

| Relationship | Entities Involved      | Cardinality | Description |
|--------------|-------------------------|-------------|--------------|
| places       | Customer – Order        | 1 : N       | A customer may place many orders; each order belongs to one customer. |
| generates    | Order – Bill            | 1 : 1       | Every order produces exactly one bill. |
| paid by      | Order – Payment         | 1 : 1       | An order is settled through one payment record. |
| contains     | Order – Order_Item      | 1 : N       | An order contains one or more order items; an item cannot exist without its order. |
| refers       | Order_Item – Product    | N : 1       | Many order items may refer to the same product. |
| belongs to   | Product – Category      | N : 1       | A category groups many products; each product belongs to one category. |
| supplies     | Seller – Product        | 1 : N       | A seller supplies many products; each product has one seller. |

## Design Constraints and Notations

- **Primary keys:** Customer_ID, Order_ID, Bill_No, Payment_ID, Category_ID, Seller_ID, Product_ID.
- **Composite key:** Order_Item is identified by (Order_ID, Product_ID) plus the partial key Item_No.
- **Weak entity:** Order_Item has no independent existence; drawn with a double rectangle, identifying relationship `contains` drawn with a double diamond, total participation in that relationship.
- **Multi-valued attribute:** Phone (a customer may register more than one contact number) — shown in braces `{ }`, implemented as a separate table.
- **Specialization/generalization:** Customer → Retail_Customer / Corporate_Customer; Payment → Card_Payment / UPI_Payment / Net_Banking_Payment.
- **Participation constraints:** Total participation between Order_Item–Order and Order–Bill; partial participation for Seller in `supplies`.
- **Referential integrity:** Every FK must match a PK value in its parent table.

## Conclusion

The E-R diagram models the platform with eight entities and seven relationship sets,
capturing the chain Customer → Order → Order_Item → Product, the 1:1 links
Order → Bill / Order → Payment, and the classification links Product → Category and
Seller → Product. It demonstrates a composite key, a weak entity, a multi-valued
attribute, specialization/generalization, and both total and partial participation,
and can be converted directly into a normalized relational schema (see Experiment 2).

> Note: The diagram image itself was drawn in the lab notebook/tool — add a screenshot
> or exported image of the E-R diagram to this folder (e.g. `er-diagram.png`) before
> pushing, if your teacher wants the visual included.
