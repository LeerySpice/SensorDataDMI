
## ImportBson.R 
- Lectura de la base measurements.bson usando librería *mongolite*. 
- La base se transforma a *json* (*Data/data.json*) y, luego, a Rda.


## ClusterData.R

- Importar data y asignar a columnas el _id de medición
- Sustraer los datos de acceleración y micrófono del sensor
- Escala toda la base de datos
- Optimimza número de cluster via NBclust (26 tests)

|  |  KL |  CH | Hartigan |    CCC |   Scott  |     Marriot | TrCovW |  TraceW  | Friedman | 
| ----------- | ----------- | ----------- | ----------- |----------- | ----------- |----------- | ----------- |----------- | ----------- | 
| Number_clusters | 4.0000 | 4.000 |  4.0000 | 8.0000 |   4.000 | 4.000000e+00  |     5  |  4.000 |  6.0000 | 
| Value_Index  | 1.9755 | 296.871 | 110.2351 | 14.1814 | 3495.809 | 2.052813e+198 | 1141934 | 6145.621 | 704.2995 | 
|  |  **Cindex** |  **DB** | **Silhouette** |  **Duda** | **PseudoT2** |   **Beale** | **Ratkowsky** | **Ball** | **PtBiserial** | 
| Number_clusters | 3.0000 | 6.0000 | 6.0000 | 2.0000 |  2.0000 | 2.0000 |   4.0000 |    3.00  |   4.0000 | 
| Value_Index  | 0.0726 | 1.2488  |   0.3066 | 1.0091 | -6.3414 | -0.6202  |  0.3394 | 15451.51  |   0.3607 | 
|  |  **McClain** |  **Dunn** | **Hubert** | **SDindex** | **Dindex** | **SDbw** |  **Rubin** | **Frey** |
| Number_clusters | 2.000 | 5.0000  |    0 | 2.0000   |   0 | 2.0000 |  -0.1027 |  1 |
| Value_Index  | 0.544 | 0.0331 |   0 |  1.0757 |   0 | 1.0561 | -0.1027 |  NA |

Conclusion: **According to the majority rule, the best number of clusters is  4**


| Optimization cluster     | Kmeans  k=4    |
|------------|-------------|
| <img src="https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/optimz_nb.cluster.png" width="550"> | <img src="https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/kmeans_cluster.png" width="550"> |

- Merge en base de datos con indices de cluster como factor, via *km.res.cluster*
- Guarda base como dfcluster.Rda con km.res.cluster como factor

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

## MLData.R
- Leer base de datos de cluster
- Asignar misma longitud de vector a las cuatro clases, tomando la longitud minima de la clases (cluster 4)
```{r }
df <- readRDS("Data/dfcluster.Rda")
for (x in 1:4) {
  assign(paste0("i",x), which(df$km.res.cluster==x))
  assign(paste0("ic",x), df[get(paste0("i",x)),][sample(1:length(df[get(paste0("i",x)),1]),min(table(df$km.res.cluster))),])
}
```
- Dataframe de 1000 casos, se divide en 80% entrenamiento y 20% validación
- Se exploran las variables
- Se entrena usando métodos LDA, CART, KNN, SVM, RF
- Summary a resultados

Number of resamples: 10 

**Accuracy** 
|    |  Min. |  1st Qu. |   Median  |    Mean |  3rd Qu.  |    Max. | NA's |
| ----------- | ----------- | ----------- | ----------- |----------- | ----------- |----------- | ----------- |
|lda  | 0.8684211 | 0.9243421 | 0.9539474 | 0.9409761 | 0.9609108 | 0.9740260  |  0 |
|cart | 0.7105263 | 0.7755895 | 0.9013158 | 0.8584906 | 0.9309211 | 0.9358974  |  0 |
|knn | 0.8947368 | 0.9243421 | 0.9407895 | 0.9372316 | 0.9574077 | 0.9736842  |  0 |
|svm | 0.9210526 | 0.9482184 | 0.9605263 | 0.9646770 | 0.9835526 | 1.0000000  |  0 |
|rf |  0.9342105 | 0.9516700 | 0.9605263 | 0.9633441 | 0.9739405 | 0.9870130 |   0 |

Kappa 
| |Min.|1st Qu. |   Median |     Mean |  3rd Qu.  |    Max. |NA's |
| ----------- | ----------- | ----------- | ----------- |----------- | ----------- |----------- | ----------- |
|lda | 0.8245614 | 0.8991228 | 0.9385965 | 0.9212981 | 0.9478657 | 0.9653543  |  0 |
|cart | 0.6140351 | 0.7019056 | 0.8684211 | 0.8114706 | 0.9078947 | 0.9145299  |  0 |
|knn | 0.8596491 | 0.8991228 | 0.9210526 | 0.9163163 | 0.9431996 | 0.9649123   | 0 |
|svm | 0.8947368 | 0.9309534 | 0.9473684 | 0.9529000 | 0.9780702 | 1.0000000  |  0 |
|rf |  0.9122807 | 0.9355601 | 0.9473684 | 0.9511250 | 0.9652497 | 0.9826850  |  0 |
