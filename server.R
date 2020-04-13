#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


insample=read_excel("interest_rate_data.xlsx", sheet="In Sample", range = "A1:C200", col_names = T)
insample=insample[complete.cases(insample),]
projections=read_excel("interest_rate_data.xlsx", sheet="Projections", range = "A1:F300", col_names = T)
projections=projections[complete.cases(projections),]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  observeEvent(input$resetAll, {
    reset("form")
  })
  draw_chart1=function(){
  insample_prediction= reactive({input$intercept+input$libor_3m*insample$`LIBOR 3M`+input$swap_5y*insample$`SWAP 5Y`+
      input$swap_5y_u1*ifelse(insample$`SWAP 5Y`-input$bp1<0,0,insample$`SWAP 5Y`-input$bp1)+
      input$swap_5y_u2*ifelse(insample$`SWAP 5Y`-input$bp2<0,0,insample$`SWAP 5Y`-input$bp2)})
  #View(insample_prediction())
  insample$Prediction=insample_prediction()
  #View(insample)
   insample_reshaped=insample%>%
     gather("Category","Fix Mortgage %",3:4)
   #View(insample_reshaped)
    ggplot(insample)+
      geom_point(aes(x=`SWAP 5Y`,y=Actual, color='Actual'))+
      geom_line(aes(x=`SWAP 5Y`,y=Prediction, color='Prediction'))+
      scale_y_continuous(labels=percent)+
      geom_vline(xintercept = input$bp1, linetype="dashed", color = "blue", size=1)+
    geom_vline(xintercept = input$bp2, linetype="dashed", color = "red", size=1) 
   # ggplot(insample_reshaped,aes(x=`SWAP 5Y`,y=`Fix Mortgage %`))+
   # geom_point(aes(color = Category, linetype = Category))+
   #   scale_y_continuous(labels=percent)
  }
  
  #View(insample_reshaped)
  #insample_reshaped=reactive({insample_reshaped})
  draw_chart=function(df,int,lib,sw,bp1,sw_u1,bp2,sw_u2){
  prediction_ref= reactive({int+lib*projections$`LIBOR 3M REF`+sw*projections$`SWAP 5Y REF`+
                                 sw_u1*ifelse(projections$`SWAP 5Y REF`-bp1<0,0,projections$`SWAP 5Y REF`-bp1)+
                                 sw_u2*ifelse(projections$`SWAP 5Y REF`-bp2<0,0,projections$`SWAP 5Y REF`-bp2)})
  prediction_up= reactive({int+lib*projections$`LIBOR 3M UP`+sw*projections$`SWAP 5Y UP`+
                                        sw_u1*ifelse(projections$`SWAP 5Y UP`-bp1<0,0,projections$`SWAP 5Y UP`-bp1)+
                                        sw_u2*ifelse(projections$`SWAP 5Y UP`-bp2<0,0,projections$`SWAP 5Y UP`-bp2)})
  prediction_down= reactive({int+lib*projections$`LIBOR 3M DOWN`+sw*projections$`SWAP 5Y DOWN`+
                             sw_u1*ifelse(projections$`SWAP 5Y DOWN`-bp1<0,0,projections$`SWAP 5Y DOWN`-bp1)+
                             sw_u2*ifelse(projections$`SWAP 5Y DOWN`-bp2<0,0,projections$`SWAP 5Y DOWN`-bp2)})
  projection_plot_data=data.frame(mon=1:nrow(projections),
                REF=prediction_ref(),UP=prediction_up(),DOWN=prediction_down())
  #View(projection_plot_data)
  projection_plot_reshaped=projection_plot_data %>%
    gather("Scenario","FIX Mortgage %",2:4)
  ggplot(projection_plot_reshaped,aes(x=mon,y=`FIX Mortgage %`))+
      geom_line(aes(color = Scenario, linetype = Scenario))+
    scale_y_continuous(labels=percent)

  }
  # input$intercept+input$libor_3m*projections$`LIBOR 3M REF`+input$swap_5y*projections$`SWAP 5Y REF`+
  #   input$swap_5y_u1*max(projections$`SWAP 5Y REF`-input$bp1,0)+
  #   input$swap_5y_u2*max(projections$`SWAP 5Y REF`-input$bp2
  #p2=reactive({ggplot(insample)+geom_line(aes(`SWAP 5Y`,Actual))+
   #   geom_line(aes(`SWAP 5Y`,prediction))})
  
  output$plotgraph1 <- renderPlot({
    draw_chart(projections, input$intercept, input$libor_3m, input$swap_5y, input$bp1, input$swap_5y_u1, input$bp2, input$swap_5y_u2)
    #draw_chart1()
    #ptlist=list(draw_chart(projections, input$intercept, input$libor_3m, input$swap_5y, input$bp1, input$swap_5y_u1, input$bp2, input$swap_5y_u2),draw_chart1())
    #grid.arrange(grobs=ptlist, ncol=1)
  })
  output$plotgraph2 <- renderPlot({
    #draw_chart(projections, input$intercept, input$libor_3m, input$swap_5y, input$bp1, input$swap_5y_u1, input$bp2, input$swap_5y_u2)
    draw_chart1()
    #ptlist=list(draw_chart(projections, input$intercept, input$libor_3m, input$swap_5y, input$bp1, input$swap_5y_u1, input$bp2, input$swap_5y_u2),draw_chart1())
    #grid.arrange(grobs=ptlist, ncol=1)
  })
  
})
