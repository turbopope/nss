| Short | Long | Alias | Description |
| --- | --- | --- | --- |
| $z$ | | $= \left<k\right>$ | Average degree |
| $k$ | | | Some degree / Number of neighbors |
| $G_0(x)$ | $= \sum_k \rho_kp_kx^k$ | | PGF for vulnerable vertices |
| $\rho_k$ | $= olol$ | | Propabilty that a node with k neighbors is vulerable |
| $p_k$ | | | Propabilty that a node has k neighbors |
| $f(\phi)$ | | | PDF for a threshold |
| $\phi$ | | | Some threshold |
| $G_0(1)$ | | $= P_v$ | Vulnerable fraction of the network/Chance that a node is vulnerable |
| $G_0'(1)$ | $= \sum_kk\rho_kp_kx^{k-1}$ | $= z_v$ | Average degree of all vulnerable vertices |
| $G_1(x)$ | $= \frac{\sum_kk\rho_kp_kx^{k-1}}{\sum_kkp_k} = \frac{G_0'(x)}{z}$ | | PGF for a vulerable node adjacent to an initially chosen node |
| $H_0(x)$ | $= \sum_nq_nx^n = (1 - G_1(1)) + xG_1(H_1(x))$ |
| $q_n$ | | | Propability that a node belongs to a vulnerable cluster of size $n$ |
| $H_0(x)$ | $= \sum_nr_nx^n = (1 - G_0(1)) + xG_0(H_1(x))$
| $r_n$ | | | Propabilty that a node is a neighbor of a node in a vulnerable cluster of size $n$ |
| $H_0'(1)$ | $ugh$ | $\left<n_v\right> = \left<n\right>$ | Average vulnerable cluster size |

* **PGF -- Propabilty Generating Function**: Where do I even begin?
* **PDF -- Propability Density Function**: Propabilty function for a continuous random variable
