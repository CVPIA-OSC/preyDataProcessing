#plotly by author
all_prey %>%
  plot_ly(
    y = ~prey_density,
    color = ~author,
    type = 'violin',
    box = list(
      visible = T
    ),
    meanline = list(
      visible = T
    )
  ) %>%
  layout(
    yaxis = list(
      title = "",
      zeroline = F
    )
  )

#ploty by watershed
all_prey %>%
  plot_ly(
    y = ~prey_density,
    color = ~watershed,
    type = 'violin',
    box = list(
      visible = T
    ),
    meanline = list(
      visible = T
    )
  ) %>%
  layout(
    yaxis = list(
      title = "",
      zeroline = F
    )
   )




                