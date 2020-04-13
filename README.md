# Expert-Judgment-Tool
Expert Judgment Tool that displays model output so that experts can provide inputs that aren't captured in historical data(for example, extreme scenarios that haven't occured yet). This will enable us to adjust the coefficients of the model and provide updated projections that can be ratified by experts.

Input for the code is an excel sheet with two tabs. Tab 1 named 'In Sample' contains data for plotting insample fit. For this model, relevant variables included in this sheet are 'LIBOR 3M', 'SWAP 5Y' and 'Actual'(target varaible). Tab 2 named 'Projections' contains the predictors for different scenarios
