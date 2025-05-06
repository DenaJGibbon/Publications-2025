
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Siamang-noise

<!-- badges: start -->
<!-- badges: end -->

The goal of **Siamang-noise** is to analyze the impact of various
playback conditions on the movement behavior of Siamangs. This project
uses mixed-effects modeling and other statistical techniques to evaluate
the effects of different noise conditions on the distances traveled by
Siamangs.

## Features

- Data preprocessing and reshaping using `tidyr` and `plyr`.
- Mixed-effects modeling with `lme4` for analyzing playback responses.
- Model diagnostics using `DHARMa` and visualization with `sjPlot`.
- Statistical summaries and comparisons using AIC and other metrics.
- Log-transformation and normalization of response variables for robust
  analysis.

## Data

The project uses data stored in the `data/SpecificTravelandPlaybackData`
directory, including:

- Distance traveled under various playback conditions.
- Pre-playback and post-playback measurements.
- Group-specific data for different sites.

## Analysis Workflow

1.  **Data Compilation**: Distance data is compiled from Excel files in
    the `Distance` subdirectory.
2.  **Data Transformation**: Data is reshaped from wide to long format
    and recoded for better interpretability.
3.  **Modeling**: Mixed-effects models are defined to evaluate the
    effects of playback conditions.
4.  **Diagnostics**: Residual simulations and diagnostic plots are
    generated to assess model performance.
5.  **Visualization**: Model coefficients and other results are
    visualized using `sjPlot` and `ggpubr`.

## Citation

If you use this project in your research, please cite the following work
(currently under review):

D’Agostino, J., Clink, D. J., Abdullah, A., & Spehar, S. (under review).
Siamangs (*Symphalangus syndactylus*) modify travel behavior in response
to playback experiments of anthropogenic sound events.
