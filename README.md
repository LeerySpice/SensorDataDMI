
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
- Se grafican por clúster con ggplot2
![image](https://github.com/LeerySpice/SensorDataDMI/blob/master/Cluster/main_cluster.png)
- Visualización via *plotly* en Viewer de Rstudio

## MLData.R
- Leer base de datos de cluster
- Asignar misma longitud de vector a las cuatro clases, tomando la longitud minima de la clases (cluster 4)
```{r }
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

## AllMLData.R

- Leer base de datos completa de cluster (37041 casos) 
- se divide en 80% entrenamiento y 20% validación
- Se entrena usando métodos LDA, CART, KNN, SVM, RF

 
|Accuracy |  Min.  |   Mean |    Max. | Kappa |    Min. |   Mean  |  Max. |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
|lda | 0.9348633 | 0.9443564 | 0.9554506 | lda | 0.8967683 |0.9118418 |0.9294735 |
|cart | 0.9217538 | 0.9239752 | 0.9274384 | cart | 0.8759175 |0.8792006 |0.8853635 |
|knn | 0.9615255 | 0.9651760 | 0.9699831 |knn |0.9390702 |0.9448675 |0.9525208 | 
|svm | 0.9807627 | 0.9839379 | 0.9858300 | svm | 0.9695771 |0.9745701 |0.9775614  |
|rf  | 0.9350649 | 0.9712735 | 1.0000000  |rf | 0.9133663 |0.9616909 |1.0000000  | 


![image](https://github.com/LeerySpice/SensorDataDMI/blob/master/Models/DotplotModels.png)

### Usando RandomForest

```{r }
predictions <- predict(fit.rf, validation)
confusionMatrix(predictions, validation$km.res.cluster)
```

#### Confusion Matrix

|   | 1  | 2    | 3    | 4    |
|---|----|------|------|------|
| 1 | 47 |   0  |  31  |   7  |
| 2 |  0 | 2240 |  33  |   6  |
| 3 |  0 |  66  | 3333 |   4  |
| 4 |  0 |  41  |  140 | 1457 |

#### Overall Statistics
                                            
               Accuracy : 0.9556          
                 95% CI : (0.9506, 0.9602)
    No Information Rate : 0.4777          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9305  
                                                

#### Statistics by Class:

|                               | Class: 1 | Class: 2 | Class: 3 | Class: 4 |
|-------------------------------|----------|----------|----------|----------|
| Sensitivity                   | 1.000000 | 0.9544   | 0.9421   | 0.9885   |
| Specificity                   | 0.994836 | 0.9923   | 0.9819   | 0.9693   |
| Pos Pred Value                | 0.552941 | 0.9829   | 0.9794   | 0.8890   |
| Neg Pred Value                | 1.000000 | 0.9791   | 0.9488   | 0.9971   |
| Prevalence                    | 0.006346 | 0.3169   | 0.4777   | 0.1990   |
| Detection Rate                | 0.006346 | 0.3025   | 0.4500   | 0.1967   |
| Detection Prevalence 0.011477 | 0.3077   | 0.4595   | 0.2213   | 0.2212   |
| Balanced Accuracy             | 0.997418 | 0.9734   | 0.9620   | 0.9789   |
