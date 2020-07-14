
## ImportBson.R 
- Lectura de la base measurements.bson usando librería *mongolite*. 
- La base se transforma a *json* (*Data/data.json*) y, luego, a Rda.


## ClusterData.R

- Importar data y asignar a columnas el _id de medición
- Sustraer los datos de acceleración y micrófono del sensor
- Escala toda la base de datos
- Optimimza número de cluster via NBclust (26 tests)

|  |  KL |  CH | Hartigan |    CCC |   Scott  |     Marriot | TrCovW |  TraceW  | Friedman |  Rubin |
| ----------- | ----------- | ----------- | ----------- |----------- | ----------- |----------- | ----------- |----------- | ----------- | ----------- |
| Number_clusters | 4.0000 | 4.000 |  4.0000 | 8.0000 |   4.000 | 4.000000e+00  |     5  |  4.000 |  6.0000 | 4.0000 |
| Value_Index  | 1.9755 | 296.871 | 110.2351 | 14.1814 | 3495.809 | 2.052813e+198 | 1141934 | 6145.621 | 704.2995 | -0.1027 |
|  |  **Cindex** |  **DB** | **Silhouette** |  **Duda** | **PseudoT2** |   **Beale** | **Ratkowsky** | **Ball** | **PtBiserial** | **Frey** |
| Number_clusters | 3.0000 | 6.0000 | 6.0000 | 2.0000 |  2.0000 | 2.0000 |   4.0000 |    3.00  |   4.0000 |  1 |
| Value_Index  | 0.0726 | 1.2488  |   0.3066 | 1.0091 | -6.3414 | -0.6202  |  0.3394 | 15451.51  |   0.3607 |  NA |
|  |  **McClain** |  **Dunn** | **Hubert** | **SDindex** | **Dindex** | **SDbw** | 
| Number_clusters | 2.000 | 5.0000  |    0 | 2.0000   |   0 | 2.0000 |  
| Value_Index  | 0.544 | 0.0331 |   0 |  1.0757 |   0 | 1.0561 |

![Numero cluster optimizado](https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/optimz_nb.cluster.png)

Among all indices: 
* 2 proposed  0 as the best number of clusters
* 1 proposed  1 as the best number of clusters
* 6 proposed  2 as the best number of clusters
* 2 proposed  3 as the best number of clusters
* 9 proposed  4 as the best number of clusters
* 2 proposed  5 as the best number of clusters
* 3 proposed  6 as the best number of clusters
* 1 proposed  8 as the best number of clusters

Conclusion: **According to the majority rule, the best number of clusters is  4**

## Kmeans 
![image](https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/kmeans_cluster.png)


```{r load}

```

## Including Plots

You can also embed plots, for example:
