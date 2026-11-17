# Findings and recommendations

**Scope:** Olist Brazilian e-commerce orders, January 2017 to August 2018.
**Basis:** revenue is the item price (freight excluded); canceled and unavailable orders are excluded; a customer is counted once by `customer_unique_id`.
All figures come from the SQL model and match the Power BI dashboard and the Excel pivot check.

## Summary

| Metric | Value |
|---|---|
| Revenue | R$13.45M |
| Orders | 97,905 |
| Average order value | R$137.37 |
| Unique customers | 94,707 |
| Late deliveries | 6.8% of delivered orders |
| Revenue growth, Jan-Aug 2018 vs Jan-Aug 2017 | +138% |

The business grew fast, but through more orders rather than bigger ones, and growth depends on a few places, a few categories and customers who rarely come back. The findings below cover each of these.

---

## 1. Growth comes from volume, not basket size

- **What we see:** Jan-Aug revenue rose from R$3.08M (2017) to R$7.34M (2018), and orders rose from 22,562 to 53,530. The average order value stayed close to R$137.
- **Why it matters:** growth depends on bringing in more customers. Nothing in the data shows customers spending more per order.
- **Recommendation:** keep acquisition going, and test ways to raise the basket (bundles, free-shipping thresholds, cross-selling inside the top categories).
- **Track:** average order value and items per order, month by month.

## 2. November is the peak month

- **What we see:** monthly revenue peaks in November 2017 at about R$1.0M, most likely a Black Friday effect, before settling at R$0.85-1.0M in 2018.
- **Why it matters:** demand spikes put pressure on stock and carriers, and late deliveries do the most damage when volume is highest.
- **Recommendation:** plan stock and carrier capacity for November early, and agree delivery commitments with carriers before the peak.
- **Track:** late-delivery rate and delivery days for November against other months.

## 3. Revenue is concentrated in the Southeast

- **What we see:** the Southeast brings in 65% of revenue (R$8.79M), followed by the South (14%), Northeast (11%), Central-West (6%) and North (2%). Sao Paulo is the largest state for both customers and sellers.
- **Why it matters:** the business relies on one region, so problems there (competition, logistics) affect almost everything. The other regions are a small share of revenue.
- **Recommendation:** treat the Northeast and North as a separate growth question, but fix delivery and shipping costs there first (findings 4 and 5) before spending on marketing.
- **Track:** revenue share by region, and orders per region over time.

## 4. Late deliveries cost about two review stars

- **What we see:** 6.8% of delivered orders arrive after the estimated date. Late orders average about 2.3 stars against about 4.3 for on-time orders. The late rate is highest in northeastern states: AL (21.5%), MA (17.5%), SE (15.4%), PI (13.9%) and CE (13.8%). Rio de Janeiro also stands out at 12.1% on a much larger volume (about 12,300 orders), so it affects more customers than any single northeastern state.
- **Why it matters:** delivery performance is the clearest driver of low reviews in this data. It affects customer satisfaction, and low reviews reduce future sales.
- **Recommendation:** focus on reducing late deliveries in the worst states: review carrier performance there, and set more realistic estimated delivery dates where deliveries regularly run long, so customers are not promised dates that are missed. Start with Rio de Janeiro because of its volume, and the Northeast because of its rate.
- **Track:** late rate and average review score by state, month by month.
- **Note:** this shows a strong link, not proof of cause. Small states also have few orders, so their rates move more.

## 5. Shipping is expensive and slow in the Northeast and North

- **What we see:** among states with more than 500 orders, freight adds the most to the price in MA (26.2% of item price), PE (22.6%), PB (22.3%), PA (21.6%) and CE (21.4%). Average delivery in these states is 18 to 24 days, against about 12.5 days overall. Sao Paulo, by far the largest state, pays 13.8% freight and gets its orders in 8.7 days on average.
- **Why it matters:** a customer who pays a fifth or more on top of the price and waits three weeks is less likely to buy again, and this is where the late deliveries in finding 4 are concentrated.
- **Recommendation:** pilot a regional fulfillment or carrier arrangement for the Northeast, renegotiate freight rates on the busiest routes, and test a free-shipping threshold there.
- **Track:** freight as a share of price, delivery days and late rate for pilot states against a control group.

## 6. Only 3% of customers buy a second time

- **What we see:** 2,875 of 94,707 unique customers placed more than one valid order (3.0%).
- **Why it matters:** almost every order needs a newly acquired customer, which is costly. Each extra percentage point of repeat buyers is about 950 customers who come back.
- **Recommendation:** start a retention programme: a follow-up message after delivery, a reorder offer in the categories people buy most, and a loyalty incentive. Fix the late-delivery problem first, because unhappy customers are unlikely to return.
- **Track:** repeat-purchase rate by month of first order, and by category.
- **Note:** the dataset covers a limited period, so some customers may still return after the data ends. The real repeat rate could be higher.

## 7. Category mix: a strong top end and a few weak spots

- **What we see:** the top five categories (Health Beauty, Watches Gifts, Bed Bath Table, Sports Leisure, Computers Accessories) make up about 40% of revenue. Health Beauty leads with R$1.25M. Among larger categories, Office Furniture has the lowest review score (3.63) with an 8.1% late rate, Bed Bath Table is below 4.0 (3.97), and Baby also has an 8.1% late rate.
- **Why it matters:** the biggest categories carry the business, so marketing is best spent where it already works. Categories with low scores and late deliveries risk hurting the brand.
- **Recommendation:** keep investing in the top categories. For Office Furniture and Bed Bath Table, look at product quality, seller performance and delivery (large items are harder to ship).
- **Track:** review score and late rate by category and by seller.

## 8. Credit cards and instalments dominate payments

- **What we see:** 75.5% of orders are paid by credit card, with 3.6 instalments on average, and these orders have the highest average order value (R$143.61). Boleto is used for 19.9% of orders (R$121.67), vouchers for 3.1% (R$94.89) and debit cards for 1.5% (R$119.64).
- **Why it matters:** instalments appear to support larger purchases. Customers who pay by boleto buy smaller baskets.
- **Recommendation:** keep instalment options prominent at checkout, and test whether showing instalment prices on higher-priced products lifts conversion.
- **Track:** conversion and average order value by payment type.
- **Note:** the instalment link is a hypothesis to test, not proven from this data.

---

## Limitations

- The data covers January 2017 to August 2018 only. Months outside this window were sparse and are excluded.
- The data has no cost or margin information, so the analysis is about revenue and service quality, not profit.
- Revenue excludes freight.
- Findings 4, 7 and 8 show associations. They do not prove cause.

## Suggested next steps

1. Split delivery time into seller handling time (purchase to carrier pickup) and carrier transit time (pickup to delivery), using the order timestamps, to find where delays start.
2. Estimate the revenue at risk from late deliveries using the review gap.
3. Compare repeat-purchase rates by first category and by first review score.
