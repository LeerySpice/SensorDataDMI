
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

Conclusion: **According to the majority rule, the best number of clusters is  4**


| Optimization cluster     | Kmeans  k=4    |
|------------|-------------|
| <img src="https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/optimz_nb.cluster.png" width="550"> | <img src="https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/kmeans_cluster.png" width="550"> |

- Merge en base de datos con indices de cluster como factor, via *km.res.cluster*
- Guarda base como dfcluster.Rda

```{r }
for (x in 1:4) {
  assign(paste0("i",x), which(df$km.res.cluster==x))
  assign(paste0("DC",x), df[get(paste0("i",x)),][,-97])
  assign(paste0("PDC",x), colMeans(get(paste0("DC",x))))
  saveRDS(get(paste0("DC",x)),file=paste0('Data/DC', x, '.Rda'))
{
```
- Obtiene el promedio de las clases
- Se grafican por clúster co ggplot2
![image](https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/main_cluster.png)
- Visualización via *plotly* en Viewer de Rstudio
