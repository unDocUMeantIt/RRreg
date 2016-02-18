## used as the plugin's main component
# name of the active component, relevant for help page content
rk.set.comp("Univariate Analysis")

## dialog section

varsUni <- rk.XML.varselector(id.name="varsUni")
# response
varUniResponse <- rk.XML.varslot(
  label="Responses (dichotomous vector)",
  source=varsUni,
  classes=c("numeric"),
  required=TRUE,
  id.name="varUniResponse"
)
# data
varUniData <- rk.XML.varslot(
  label="Data (data frame)",
  source=varsUni,
  classes=c("data.frame"),
  required=FALSE,
  id.name="varUniData"
)

# model
uniDrpModel <- rk.XML.dropdown(
  label="Model specification",
  options=list(
    "Warner"=c(val="Warner", chk=TRUE),
    "UQTknown"=c(val="UQTknown"),
    "UQTunknown"=c(val="UQTunknown"),
    "Mangat"=c(val="Mangat"),
    "Kuk"=c(val="Kuk"),
    "FR"=c(val="FR"),
    "Crosswise"=c(val="Crosswise"),
    "CDM"=c(val="CDM"),
    "CDMsym"=c(val="CDMsym"),
    "SLD"=c(val="SLD"),
    "mix.norm"=c(val="mix.norm"),
    "mix.exp"=c(val="mix.exp"),
    "mix.unknown"=c(val="mix.unknown"),
    "custom"=c(val="custom")
  ),
  id.name="uniDrpModel"
)

# p
uniFrmProbabilities <- rk.XML.frame(
  rk.XML.row(
    uniSpinp1 <- rk.XML.spinbox(
      label="p<sub>1</sub>",
      min=0,
      max=1,
      initial=1,
      id.name="uniSpinp1"
    ),
    uniSpinp2 <- rk.XML.spinbox(
      label="p<sub>2</sub>",
      min=0,
      max=1,
      initial=0,
      id.name="uniSpinp2"
    ),
    uniSpinp3 <- rk.XML.spinbox(
      label="p<sub>3</sub>",
      min=0,
      max=1,
      initial=0,
      id.name="uniSpinp3"
    ),
    uniInputp1 <- rk.XML.input(
      label="p<sub>1</sub>",
      initial="1/1",
      id.name="uniInputp1"
    ),
    uniInputp2 <- rk.XML.input(
      label="p<sub>2</sub>",
      initial="0/1",
      id.name="uniInputp2"
    ),
    uniInputp3 <- rk.XML.input(
      label="p<sub>3</sub>",
      initial="0/1",
      id.name="uniInputp3"
    )
  ),
  rk.XML.row(
    uniChkProbInput <- rk.XML.cbox("Manual input")
  ),
  label="Probabilities",
  id.name="uniFrmProbabilities"
)
  

# group
varUniGroup <- rk.XML.varslot(
  label="Groups (numeric vector)",
  source=varsUni,
  classes=c("numeric"),
  required=FALSE,
  id.name="varUniGroup"
)

# MLest
uniFrmMLest <- rk.XML.frame(
  uniChkMLest <- rk.XML.cbox(label="Maximum likelihood instead of moment estimates", id.name="uniChkMLest"),
  label="Options",
  id.name="uniFrmMLest"
)

uniSaveResults <- rk.XML.saveobj("Save results to workspace", initial="RRUniResult")

RRreg.rk.UniDialog <- rk.XML.dialog(
  rk.XML.row(
    rk.XML.col(
      varsUni
    ),
    rk.XML.col(
      varUniData,
      varUniResponse,
      varUniGroup,
      uniDrpModel,
      uniFrmProbabilities,
      rk.XML.stretch(),
      uniFrmMLest,
      uniSaveResults
    )
  ),
  label="Univariate Analysis for Randomized Response Data"
)

## logic section
RRreg.rk.UniLogic <- rk.XML.logic(
  rk.XML.connect(governor="current_object", client=varUniData, set="available"),
  rk.XML.connect(governor=varUniData, client=varsUni, get="available", set="root"),
  # replace spinboxes with manual input fields
  rk.XML.connect(governor=uniChkProbInput, client=uniSpinp1, not=TRUE, set="visible"),
  rk.XML.connect(governor=uniChkProbInput, client=uniInputp1, set="visible"),
  rk.XML.connect(governor=uniChkProbInput, client=uniSpinp2, not=TRUE, set="visible"),
  rk.XML.connect(governor=uniChkProbInput, client=uniInputp2, set="visible"),
  rk.XML.connect(governor=uniChkProbInput, client=uniSpinp3, not=TRUE, set="visible"),
  rk.XML.connect(governor=uniChkProbInput, client=uniInputp3, set="visible"),
  # two p
  uniLgcModelUQTknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="UQTknown"), id.name="uniLgcModelUQTknown"),
  uniLgcModelUQTunknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="UQTunknown"), id.name="uniLgcModelUQTunknown"),
  uniLgcModelKuk <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="Kuk"), id.name="uniLgcModelKuk"),
  uniLgcModelFR <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="FR"), id.name="uniLgcModelFR"),
  uniLgcModelCDM <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="CDM"), id.name="uniLgcModelCDM"),
  uniLgcModelCDMsym <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="CDMsym"), id.name="uniLgcModelCDMsym"),
  uniLgcModelSLD <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="SLD"), id.name="uniLgcModelSLD"),
  uniLgcModelcustom <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="custom"), id.name="uniLgcModelcustom"),
  # three p
  uniLgcModelmixNorm <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.norm"), id.name="uniLgcModelmixNorm"),
  uniLgcModelmixExp <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.exp"), id.name="uniLgcModelmixExp"),
  uniLgcModelmixUnknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.unknown"), id.name="uniLgcModelmixUnknown"),
  uniLgcNeedsP2 <- rk.XML.convert(
    sources=list(
      uniLgcModelUQTknown,
      uniLgcModelUQTunknown,
      uniLgcModelKuk, uniLgcModelFR,
      uniLgcModelCDM,
      uniLgcModelCDMsym,
      uniLgcModelSLD,
      uniLgcModelcustom,
      uniLgcModelmixNorm,
      uniLgcModelmixExp,
      uniLgcModelmixUnknown
    ),
    mode=c(or=""),
    id.name="uniLgcNeedsP2"
  ),
  uniLgcNeedsP3 <- rk.XML.convert(
    sources=list(
      uniLgcModelmixNorm,
      uniLgcModelmixExp,
      uniLgcModelmixUnknown
    ),
    mode=c(or=""),
    id.name="uniLgcNeedsP3"
  ),
  uniLgcEnableGroup <- rk.XML.connect(governor=uniLgcNeedsP2, client=varUniGroup, set="enabled"),
  uniLgcRequireGroup <- rk.XML.connect(governor=uniLgcNeedsP2, client=varUniGroup, set="required"),
  uniLgcEnableSP2 <- rk.XML.connect(governor=uniLgcNeedsP2, client=uniSpinp2, set="enabled"),
  uniLgcEnableSP3 <- rk.XML.connect(governor=uniLgcNeedsP3, client=uniSpinp3, set="enabled"),
  uniLgcEnableIP2 <- rk.XML.connect(governor=uniLgcNeedsP2, client=uniInputp2, set="enabled"),
  uniLgcEnableIP3 <- rk.XML.connect(governor=uniLgcNeedsP3, client=uniInputp3, set="enabled")
)

# ## wizard section

## JavaScript calculate
  uni.js.p2.enabled <- rk.JS.vars(uniSpinp2, modifiers="enabled")
  uni.js.p3.enabled <- rk.JS.vars(uniSpinp3, modifiers="enabled")
  RRreg.rk.js.calc <- rk.paste.JS(
    uni.js.response.df <- rk.JS.vars(varUniResponse, modifiers="shortname"),
    uni.js.group.df <- rk.JS.vars(varUniGroup, modifiers="shortname"),
    uni.js.p2.enabled,
    uni.js.p3.enabled,
    echo("RRUniResult <- RRuni("),
    js(
      if(varUniResponse){
        if(varUniData){
          echo("\n  response=", uni.js.response.df)
        } else {
          echo("\n  response=", varUniResponse)
        }
      } else {},
      if(varUniData){
        echo(",\n  data=", varUniData)
      } else {},
      echo(",\n  model=\"", uniDrpModel, "\""),
      if(uni.js.p3.enabled){
        if(uniChkProbInput){
          echo(",\n  p=c(", uniInputp1, ", ", uniInputp2, ", ", uniInputp3, ")")
        } else {
          echo(",\n  p=c(", uniSpinp1, ", ", uniSpinp2, ", ", uniSpinp3, ")")
        }
      } else if(uni.js.p2.enabled){
        if(uniChkProbInput){
          echo(",\n  p=c(", uniInputp1, ", ", uniInputp2, ")")
        } else {
          echo(",\n  p=c(", uniSpinp1, ", ", uniSpinp2, ")")
        }
      } else {
        if(uniChkProbInput){
          echo(",\n  p=", uniInputp1)
        } else {
          echo(",\n  p=", uniSpinp1)
        }
      },
      if(uni.js.p2.enabled && varUniGroup){
        if(varUniData){
          echo(",\n  group=", uni.js.group.df)
        } else {
          echo(",\n  group=", varUniGroup)
        }
      } else {}
    ),
    tf(uniChkMLest, opt="MLest", level=2),
    echo("\n)\n\n")
  )

## JavaScript printout
  RRreg.rk.js.print <- rk.paste.JS(
    echo("rk.print(summary(RRUniResult))\n")
  )
