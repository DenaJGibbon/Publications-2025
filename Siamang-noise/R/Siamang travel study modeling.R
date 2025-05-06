# Load required libraries
library(tidyr)  # For reshaping data (e.g., wide-to-long format)
library(lme4)   # For mixed-effects modeling
library(bbmle)  # For model comparison using AIC and other metrics
library(sjPlot) # For plots of statistical models
library(plyr)   # For data manipulation
library(DHARMa) # For model diagnostics using residual simulations
library(stringr)
library(ggpubr)


# Compile distances
DistanceFiles <- list.files('data/SpecificTravelandPlaybackData/Distance',full.names = T)

BeforeplaybackDF <- data.frame()
for(a in 1:length(DistanceFiles)){
 TempDF <-  as.data.frame(readxl::read_excel(DistanceFiles[a]))
 Condition <- "Pre-playback"
 value <- TempDF$`Distance traveled (m)`
 Site.and.Group <- str_split_fixed(basename(DistanceFiles[a]),pattern = '.xlsx', n=2)[,1]
 Tempdf <- cbind.data.frame(Site.and.Group, Condition ,value )
 BeforeplaybackDF <- rbind.data.frame(BeforeplaybackDF,Tempdf)
}

hist(BeforeplaybackDF$value)

# Load the dataset from a CSV file
TempTravelDF <- read.csv('/Users/denaclink/Downloads/Ch3PlaybackSummary.xlsx - Sheet1.csv')

# Reshape the data from wide to long format
TempTravelDFlong <- TempTravelDF %>%
  pivot_longer(
    cols = Avg.distance..m..in.5.min.pre.playback:Distance..m..in.5.min.after.jackhammer,
    names_to = "Condition",    # Name of the new column for conditions
    values_to = "value"        # Name of the new column for values
  )

# Recode the "Condition" column with more descriptive labels
TempTravelDFlong$Condition <- as.factor(plyr::revalue(TempTravelDFlong$Condition,
                                                      c("Avg.distance..m..in.5.min.pre.playback"= "Pre-playback",
                                                        "Distance..m..in.5.min.after.control..cicada."='Cicada',
                                                        "Distance..m..in.5.min.after.music"="Music",
                                                        "Distance..m..in.5.min.after.traffic"='Traffic',
                                                        "Distance..m..in.5.min.after.jackhammer" ="Jackhammer")))

TempTravelDFlong <- subset(TempTravelDFlong, Condition != "Pre-playback" & Site.and.Group != "Ketambe - IndvB" &
                             Site.and.Group !="TOTALS")

TempTravelDFlong <- rbind.data.frame(TempTravelDFlong,BeforeplaybackDF)

# Relevel the factor so "Pre-playback" becomes the reference level
TempTravelDFlong$Condition  <- relevel(TempTravelDFlong$Condition , ref = 4)

# Log-transform the response variable to normalize its distribution
TempTravelDFlong$value <- ( log(as.numeric(TempTravelDFlong$value)))

hist(TempTravelDFlong$value)

table(TempTravelDFlong$Site.and.Group,TempTravelDFlong$Condition)

# Define models
NullModel <-lme4::lmer(value ~  (1|Site.and.Group), data=TempTravelDFlong)  # Null model with random effect
Model1 <- lme4::lmer(value ~ Condition + (1|Site.and.Group), data=TempTravelDFlong)  # Full model with random effect
Model1.nore <- lm(value ~  Condition, data=TempTravelDFlong)  # Model without random effect
NullModel.nore <- lm(value ~  1, data=TempTravelDFlong)  # Model without random effect

# Plot histogram of residuals for Model1.nore
plot(hist(residuals(Model1.nore)))

# Compare models using AIC
AICctab(NullModel, Model1,weights=TRUE)

# Test for dispersion in Model1.nore
testDispersion(Model1.nore)

# Simulate residuals and plot diagnostic results
simulationOutput <- simulateResiduals(fittedModel = Model1, plot = T, n = 500)
plot(simulationOutput)

# Display summary statistics of Model1.nore
summary(Model1)

res <- performance::simulate_residuals(Model1,iterations = 500)
performance::check_residuals(res)

MuMIn::r.squaredGLMM(Model1)

# Plot model coefficients for Model1.nore

sjPlot::plot_model(Model1.nore, sort.est = TRUE, vline.color = "red", show.values = TRUE, show.p = FALSE,
                   title = "Playback response") + theme_bw()

ModelSummary <- summary(Model1)

exp(ModelSummary$coefficients[2:5,1])

#For every one-unit increase in the independent variable, our dependent variable increases by a factor of about 1.22, or 22%.
