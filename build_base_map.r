# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# TB Mapper
#
# Server-side code to build base map layers
#
# Hazim Timimi, November 2015
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Load up the shape file data
load("data/shape_file.rda")

# Color Svalbard and Jan Mayen the same as Norway
gworld[gworld$group=="SJM.1", "piece"] <- "2"
gworld[gworld$group=="SJM.2", "piece"] <- "3"
gworld[gworld$group=="SJM.3", "piece"] <- "4"

gworld[gworld$id=="SJM", "id"] <- "NOR"

levels(gworld$group) <- c(levels(gworld$group), "NOR.2", "NOR.3", "NOR.4")
gworld[gworld$group=="SJM.1", "group"] <- "NOR.2"
gworld[gworld$group=="SJM.2", "group"] <- "NOR.3"
gworld[gworld$group=="SJM.3", "group"] <- "NOR.4"


# Build the foundation layers, polygons and lines for the maps

# A layer to map all countries (so none are missing.)
base_layer <- geom_polygon(data=gworld,
                           aes(group = group),
                           colour = "grey50",
                           fill = NA)

# Great lakes
lakes <- geom_polygon(data = subset(gpoly, id=="Lakes"),
                      aes(group = group),
                      fill = I("white"),
                      colour = "grey50")

# Deal with disputed areas and boundaries
# Jammu and Kashmir
jammu_kashmir <- geom_polygon(data = subset(gpoly, id=="Jammu and Kashmir"),
                              aes(group = group),
                              fill = I("grey75"),
                              colour = "grey50")
# Abyei
abyei <- geom_polygon(data = subset(gpoly, id=="Abyei"),
                      aes(group = group),
                      fill = I("grey75"),
                      colour = "grey50",
                      linetype="dotted")

# Western Sahara
western_sahara <-	geom_polygon(data = gworld[gworld$id=='ESH',],
                               aes(group = group),
                               fill = I("grey75"),
                               colour = "grey50")

# Alternative line styles for the disputed areas
sold_grey <- geom_path(data = subset(gline, id %in% 2),
                        aes(group = group),
                        colour = "grey50")

dashed_grey_white <- geom_path(data = subset(gline, id %in% c(0,3,6,7)),
                               aes(group = group),
                               colour = "white",
                               linetype = "dashed")

dashed_grey <- geom_path(data = subset(gline, id %in% c(1,4,5)),
                         aes(group = group),
                         colour = "grey50",
                         linetype = "dashed")

dotted_grey_white <- geom_path(data = subset(gline, id %in% c(8)),
                               aes(group = group),
                               colour = "white",
                               linetype = "dotted")   # Tom's comment: 8 and 9 are the same

# Themes
theme_x <- scale_y_continuous("", breaks = NULL)
theme_y <- scale_x_continuous("", breaks = NULL)
theme_overall <- theme_bw()
