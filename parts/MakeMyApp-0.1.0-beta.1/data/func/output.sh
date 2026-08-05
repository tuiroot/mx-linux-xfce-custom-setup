#!/usr/bin/env bash

DEF_BASE_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"
DEF_ONOFF_DEBUG="ON"
DEF_ONOFF_DEBUG_TOUT="OFF"
DEF_LOG="$DEF_BASE_DIR/../makemyapp.log"
DEF_WIDTH="$( tput cols )"
DEF_MAX_WIDTH=120
(( $DEF_WIDTH > $DEF_MAX_WIDTH)) && DEF_WDITH=$DEF_MAX_WIDTH
#----------------------------------------------------------------------#
#BASE_DIR="${BASE_DIR:-"$DEF_BASE_DIR"}"

ONOFF_DEBUG="${ONOFF_DEBUG:-"$DEF_ONOFF_DEBUG"}"
ONOFF_DEBUG_TOUT="${ONOFF_DEBUG_TOUT:-OFF}"
ERR_LOG="${ERR_LOG:-"$DEF_LOG"}"

TXT_WIDTH="${TXT_WIDTH:-"$DEF_WIDTH"}"


#--------------- COLORS -----------------------------------------------#
#FGCOLOR_1="\033[38;5;1m"           # Maroon (#800000)
#FGCOLOR_2="\033[38;5;2m"           # Green (#008000)
#FGCOLOR_3="\033[38;5;3m"           # Olive (#808000)
#FGCOLOR_4="\033[38;5;4m"           # Navy (#000080)
#FGCOLOR_5="\033[38;5;5m"           # Purple (#800080)
#FGCOLOR_6="\033[38;5;6m"           # Teal (#008080)
#FGCOLOR_7="\033[38;5;7m"           # Silver (#C0C0C0)
#FGCOLOR_8="\033[38;5;8m"           # Grey (#808080)
#FGCOLOR_9="\033[38;5;9m"           # Red (#FF0000)
#FGCOLOR_10="\033[38;5;10m"         # Lime (#00FF00)
#FGCOLOR_11="\033[38;5;11m"         # Yellow (#FFFF00)
#FGCOLOR_12="\033[38;5;12m"         # Blue (#0000FF)
#FGCOLOR_13="\033[38;5;13m"         # Fuchsia (#FF00FF)
#FGCOLOR_14="\033[38;5;14m"         # Aqua (#00FFFF)
#FGCOLOR_15="\033[38;5;15m"         # White (#FFFFFF)
#FGCOLOR_16="\033[38;5;16m"         # Grey 0 (#000000)
#FGCOLOR_17="\033[38;5;17m"         # Navy (#00005F)
#FGCOLOR_18="\033[38;5;18m"         # Dark Blue (#000087)
#FGCOLOR_19="\033[38;5;19m"         # Blue 3 (#0000AF)
#FGCOLOR_20="\033[38;5;20m"         # Blue 3 (#0000D7)
#FGCOLOR_21="\033[38;5;21m"         # Blue 1 (#0000FF)
#FGCOLOR_22="\033[38;5;22m"         # Dark Green (#005F00)
#FGCOLOR_23="\033[38;5;23m"         # Deep Sky Blue 4 (#005F5F)
#FGCOLOR_24="\033[38;5;24m"         # Deep Sky Blue 4 (#005F87)
#FGCOLOR_25="\033[38;5;25m"         # Deep Sky Blue 4 (#005FAF)
#FGCOLOR_26="\033[38;5;26m"         # Dodger Blue 3 (#005FD7)
#FGCOLOR_27="\033[38;5;27m"         # Dodger Blue 2 (#005FFF)
#FGCOLOR_28="\033[38;5;28m"         # Green 4 (#008700)
#FGCOLOR_29="\033[38;5;29m"         # Spring Green 4 (#00875F)
#FGCOLOR_30="\033[38;5;30m"         # Turquoise 4 (#008787)
#FGCOLOR_31="\033[38;5;31m"         # Deep Sky Blue 3 (#0087AF)
#FGCOLOR_32="\033[38;5;32m"         # Deep Sky Blue 3 (#0087D7)
#FGCOLOR_33="\033[38;5;33m"         # Dodger Blue 1 (#0087FF)
#FGCOLOR_34="\033[38;5;34m"         # Green 3 (#00AF00)
#FGCOLOR_35="\033[38;5;35m"         # Spring Green 3 (#00AF5F)
#FGCOLOR_36="\033[38;5;36m"         # Dark Cyan (#00AF87)
#FGCOLOR_37="\033[38;5;37m"         # Light Sea Green (#00AFAF)
#FGCOLOR_38="\033[38;5;38m"         # Deep Sky Blue 2 (#00AFD7)
#FGCOLOR_39="\033[38;5;39m"         # Deep Sky Blue 1 (#00AFFF)
#FGCOLOR_40="\033[38;5;40m"         # Green 3 (#00D700)
#FGCOLOR_41="\033[38;5;41m"         # Spring Green 3 (#00D75F)
#FGCOLOR_42="\033[38;5;42m"         # Spring Green 2 (#00D787)
#FGCOLOR_43="\033[38;5;43m"         # Cyan 3 (#00D7AF)
#FGCOLOR_44="\033[38;5;44m"         # Dark Turquoise (#00D7D7)
#FGCOLOR_45="\033[38;5;45m"         # Turquoise 2 (#00D7FF)
FGCOLOR_46="\033[38;5;46m"         # Green 1 (#00FF00)
#FGCOLOR_47="\033[38;5;47m"         # Spring Green 2 (#00FF5F)
#FGCOLOR_48="\033[38;5;48m"         # Spring Green 1 (#00FF87)
#FGCOLOR_49="\033[38;5;49m"         # Medium Spring Green (#00FFAF)
#FGCOLOR_50="\033[38;5;50m"         # Cyan 2 (#00FFD7)
#FGCOLOR_51="\033[38;5;51m"         # Cyan 1 (#00FFFF)
#FGCOLOR_52="\033[38;5;52m"         # Dark Red (#5F0000)
#FGCOLOR_53="\033[38;5;53m"         # Deep Pink 4 (#5F005F)
#FGCOLOR_54="\033[38;5;54m"         # Purple 4 (#5F0087)
#FGCOLOR_55="\033[38;5;55m"         # Purple 4 (#5F00AF)
#FGCOLOR_56="\033[38;5;56m"         # Purple 3 (#5F00D7)
#FGCOLOR_57="\033[38;5;57m"         # Blue Violet (#5F00FF)
#FGCOLOR_58="\033[38;5;58m"         # Orange 4 (#5F5F00)
#FGCOLOR_59="\033[38;5;59m"         # Grey 37 (#5F5F5F)
#FGCOLOR_60="\033[38;5;60m"         # Medium Purple 4 (#5F5F87)
#FGCOLOR_61="\033[38;5;61m"         # Slate Blue 3 (#5F5FAF)
#FGCOLOR_62="\033[38;5;62m"         # Slate Blue 3 (#5F5FD7)
#FGCOLOR_63="\033[38;5;63m"         # Royal Blue 1 (#5F5FFF)
#FGCOLOR_64="\033[38;5;64m"         # Chartreuse 4 (#5F8700)
#FGCOLOR_65="\033[38;5;65m"         # Dark Sea Green 4 (#5F875F)
#FGCOLOR_66="\033[38;5;66m"         # Pale Turquoise 4 (#5F8787)
#FGCOLOR_67="\033[38;5;67m"         # Steel Blue (#5F87AF)
#FGCOLOR_68="\033[38;5;68m"         # Steel Blue 3 (#5F87D7)
#FGCOLOR_69="\033[38;5;69m"         # Cornflower Blue (#5F87FF)
#FGCOLOR_70="\033[38;5;70m"         # Chartreuse 3 (#5FAF00)
#FGCOLOR_71="\033[38;5;71m"         # Dark Sea Green 4 (#5FAF5F)
#FGCOLOR_72="\033[38;5;72m"         # Cadet Blue (#5FAF87)
#FGCOLOR_73="\033[38;5;73m"         # Cadet Blue (#5FAFAF)
#FGCOLOR_74="\033[38;5;74m"         # Sky Blue 3 (#5FAFD7)
#FGCOLOR_75="\033[38;5;75m"         # Steel Blue 1 (#5FAFFF)
#FGCOLOR_76="\033[38;5;76m"         # Chartreuse 3 (#5FD700)
#FGCOLOR_77="\033[38;5;77m"         # Pale Green 3 (#5FD75F)
#FGCOLOR_78="\033[38;5;78m"         # Sea Green 3 (#5FD787)
#FGCOLOR_79="\033[38;5;79m"         # Aquamarine 3 (#5FD7AF)
#FGCOLOR_80="\033[38;5;80m"         # Medium Turquoise (#5FD7D7)
#FGCOLOR_81="\033[38;5;81m"         # Steel Blue 1 (#5FD7FF)
#FGCOLOR_82="\033[38;5;82m"         # Chartreuse 2 (#5FFF00)
#FGCOLOR_83="\033[38;5;83m"         # Sea Green 2 (#5FFF5F)
#FGCOLOR_84="\033[38;5;84m"         # Sea Green 1 (#5FFF87)
#FGCOLOR_85="\033[38;5;85m"         # Sea Green 1 (#5FFFAF)
#FGCOLOR_86="\033[38;5;86m"         # Aquamarine 1 (#5FFFD7)
#FGCOLOR_87="\033[38;5;87m"         # Dark Slate Gray 2 (#5FFFFF)
#FGCOLOR_88="\033[38;5;88m"         # Dark Red (#870000)
#FGCOLOR_89="\033[38;5;89m"         # Deep Pink 4 (#87005F)
#FGCOLOR_90="\033[38;5;90m"         # Dark Magenta (#870087)
#FGCOLOR_91="\033[38;5;91m"         # Dark Magenta (#8700AF)
#FGCOLOR_92="\033[38;5;92m"         # Dark Violet (#8700D7)
FGCOLOR_93="\033[38;5;93m"         # Purple (#8700FF)
#FGCOLOR_94="\033[38;5;94m"         # Orange 4 (#875F00)
#FGCOLOR_95="\033[38;5;95m"         # Light Pink 4 (#875F5F)
#FGCOLOR_96="\033[38;5;96m"         # Plum 4 (#875F87)
#FGCOLOR_97="\033[38;5;97m"         # Medium Purple 3 (#875FAF)
#FGCOLOR_98="\033[38;5;98m"         # Medium Purple 3 (#875FD7)
#FGCOLOR_99="\033[38;5;99m"         # Slate Blue 1 (#875FFF)
#FGCOLOR_100="\033[38;5;100m"       # Yellow 4 (#878700)
#FGCOLOR_101="\033[38;5;101m"       # Wheat 4 (#87875F)
#FGCOLOR_102="\033[38;5;102m"       # Grey 53 (#878787)
#FGCOLOR_103="\033[38;5;103m"       # Light Slate Gray (#8787AF)
#FGCOLOR_104="\033[38;5;104m"       # Medium Purple (#8787D7)
#FGCOLOR_105="\033[38;5;105m"       # Light Slate Blue (#8787FF)
#FGCOLOR_106="\033[38;5;106m"       # Yellow 4 (#87AF00)
#FGCOLOR_107="\033[38;5;107m"       # Dark Olive Green 3 (#87AF5F)
#FGCOLOR_108="\033[38;5;108m"       # Dark Sea Green (#87AF87)
#FGCOLOR_109="\033[38;5;109m"       # Light Sky Blue 3 (#87AFAF)
#FGCOLOR_110="\033[38;5;110m"       # Light Sky Blue 3 (#87AFD7)
#FGCOLOR_111="\033[38;5;111m"       # Sky Blue 2 (#87AFFF)
#FGCOLOR_112="\033[38;5;112m"       # Chartreuse 2 (#87D700)
#FGCOLOR_113="\033[38;5;113m"       # Dark Olive Green 3 (#87D75F)
#FGCOLOR_114="\033[38;5;114m"       # Pale Green 3 (#87D787)
#FGCOLOR_115="\033[38;5;115m"       # Dark Sea Green 3 (#87D7AF)
#FGCOLOR_116="\033[38;5;116m"       # Dark Slate Gray 3 (#87D7D7)
#FGCOLOR_117="\033[38;5;117m"       # Sky Blue 1 (#87D7FF)
#FGCOLOR_118="\033[38;5;118m"       # Chartreuse 1 (#87FF00)
#FGCOLOR_119="\033[38;5;119m"       # Light Green (#87FF5F)
#FGCOLOR_120="\033[38;5;120m"       # Light Green (#87FF87)
#FGCOLOR_121="\033[38;5;121m"       # Pale Green 1 (#87FFAF)
#FGCOLOR_122="\033[38;5;122m"       # Aquamarine 1 (#87FFD7)
#FGCOLOR_123="\033[38;5;123m"       # Dark Slate Gray 1 (#87FFFF)
#FGCOLOR_124="\033[38;5;124m"       # Red 3 (#AF0000)
#FGCOLOR_125="\033[38;5;125m"       # Deep Pink 4 (#AF005F)
#FGCOLOR_126="\033[38;5;126m"       # Medium Violet Red (#AF0087)
#FGCOLOR_127="\033[38;5;127m"       # Magenta 3 (#AF00AF)
#FGCOLOR_128="\033[38;5;128m"       # Dark Violet (#AF00D7)
#FGCOLOR_129="\033[38;5;129m"       # Purple (#AF00FF)
#FGCOLOR_130="\033[38;5;130m"       # Dark Orange 3 (#AF5F00)
#FGCOLOR_131="\033[38;5;131m"       # Indian Red (#AF5F5F)
#FGCOLOR_132="\033[38;5;132m"       # Hot Pink 3 (#AF5F87)
#FGCOLOR_133="\033[38;5;133m"       # Medium Orchid 3 (#AF5FAF)
#FGCOLOR_134="\033[38;5;134m"       # Medium Orchid (#AF5FD7)
#FGCOLOR_135="\033[38;5;135m"       # Medium Purple 2 (#AF5FFF)
#FGCOLOR_136="\033[38;5;136m"       # Dark Goldenrod (#AF8700)
#FGCOLOR_137="\033[38;5;137m"       # Light Salmon 3 (#AF875F)
#FGCOLOR_138="\033[38;5;138m"       # Rosy Brown (#AF8787)
#FGCOLOR_139="\033[38;5;139m"       # Grey 63 (#AF87AF)
#FGCOLOR_140="\033[38;5;140m"       # Medium Purple 2 (#AF87D7)
#FGCOLOR_141="\033[38;5;141m"       # Medium Purple 1 (#AF87FF)
#FGCOLOR_142="\033[38;5;142m"       # Gold 3 (#AFAF00)
#FGCOLOR_143="\033[38;5;143m"       # Dark Khaki (#AFAF5F)
#FGCOLOR_144="\033[38;5;144m"       # Navajo White 3 (#AFAF87)
#FGCOLOR_145="\033[38;5;145m"       # Grey 69 (#AFAFAF)
#FGCOLOR_146="\033[38;5;146m"       # Light Steel Blue 3 (#AFAFD7)
#FGCOLOR_147="\033[38;5;147m"       # Light Steel Blue (#AFAFFF)
#FGCOLOR_148="\033[38;5;148m"       # Yellow 3 (#AFD700)
#FGCOLOR_149="\033[38;5;149m"       # Dark Olive Green 3 (#AFD75F)
#FGCOLOR_150="\033[38;5;150m"       # Dark Sea Green 3 (#AFD787)
#FGCOLOR_151="\033[38;5;151m"       # Dark Sea Green 2 (#AFD7AF)
#FGCOLOR_152="\033[38;5;152m"       # Light Cyan 3 (#AFD7D7)
#FGCOLOR_153="\033[38;5;153m"       # Light Sky Blue 1 (#AFD7FF)
#FGCOLOR_154="\033[38;5;154m"       # Green Yellow (#AFFF00)
#FGCOLOR_155="\033[38;5;155m"       # Dark Olive Green 2 (#AFFF5F)
#FGCOLOR_156="\033[38;5;156m"       # Pale Green 1 (#AFFF87)
#FGCOLOR_157="\033[38;5;157m"       # Dark Sea Green 2 (#AFFFAF)
#FGCOLOR_158="\033[38;5;158m"       # Dark Sea Green 1 (#AFFFD7)
#FGCOLOR_159="\033[38;5;159m"       # Pale Turquoise 1 (#AFFFFF)
FGCOLOR_160="\033[38;5;160m"       # Red 3 (#D70000)
#FGCOLOR_161="\033[38;5;161m"       # Deep Pink 3 (#D7005F)
#FGCOLOR_162="\033[38;5;162m"       # Deep Pink 3 (#D70087)
#FGCOLOR_163="\033[38;5;163m"       # Magenta 3 (#D700AF)
#FGCOLOR_164="\033[38;5;164m"       # Magenta 3 (#D700D7)
#FGCOLOR_165="\033[38;5;165m"       # Magenta 2 (#D700FF)
#FGCOLOR_166="\033[38;5;166m"       # Dark Orange 3 (#D75F00)
#FGCOLOR_167="\033[38;5;167m"       # Indian Red (#D75F5F)
#FGCOLOR_168="\033[38;5;168m"       # Hot Pink 3 (#D75F87)
#FGCOLOR_169="\033[38;5;169m"       # Hot Pink 2 (#D75FAF)
#FGCOLOR_170="\033[38;5;170m"       # Orchid (#D75FD7)
#FGCOLOR_171="\033[38;5;171m"       # Medium Orchid 1 (#D75FFF)
#FGCOLOR_172="\033[38;5;172m"       # Orange 3 (#D78700)
#FGCOLOR_173="\033[38;5;173m"       # Light Salmon 3 (#D7875F)
#FGCOLOR_174="\033[38;5;174m"       # Light Pink 3 (#D78787)
#FGCOLOR_175="\033[38;5;175m"       # Rosa 3 (#D787AF)
#FGCOLOR_176="\033[38;5;176m"       # Plum 3 (#D787D7)
#FGCOLOR_177="\033[38;5;177m"       # Purple (#D787FF)
#FGCOLOR_178="\033[38;5;178m"       # Gold 3 (#D7AF00)
#FGCOLOR_179="\033[38;5;179m"       # Light Goldenrod 3 (#D7AF5F)
#FGCOLOR_180="\033[38;5;180m"       # Tan (#D7AF87)
#FGCOLOR_181="\033[38;5;181m"       # Misty Rose 3 (#D7AFAF)
#FGCOLOR_182="\033[38;5;182m"       # Thistle 3 (#D7AFD7)
#FGCOLOR_183="\033[38;5;183m"       # Plum 2 (#D7AFFF)
#FGCOLOR_184="\033[38;5;184m"       # Yellow 3 (#D7D700)
#FGCOLOR_185="\033[38;5;185m"       # Khaki 3 (#D7D75F)
#FGCOLOR_186="\033[38;5;186m"       # Light Goldenrod 2 (#D7D787)
#FGCOLOR_187="\033[38;5;187m"       # Light Yellow 3 (#D7D7AF)
#FGCOLOR_188="\033[38;5;188m"       # Grey 84 (#D7D7D7)
#FGCOLOR_189="\033[38;5;189m"       # Light Steel Blue 1 (#D7D7FF)
#FGCOLOR_190="\033[38;5;190m"       # Yellow 2 (#D7FF00)
#FGCOLOR_191="\033[38;5;191m"       # Dark Olive Green 1 (#D7FF5F)
#FGCOLOR_192="\033[38;5;192m"       # Dark Olive Green 1 (#D7FF87)
#FGCOLOR_193="\033[38;5;193m"       # Dark Sea Green 1 (#D7FFAF)
#FGCOLOR_194="\033[38;5;194m"       # Honeydew 2 (#D7FFD7)
FGCOLOR_195="\033[38;5;195m"       # Light Cyan 1 (#D7FFFF)
#FGCOLOR_196="\033[38;5;196m"       # Red 1 (#FF0000)
#FGCOLOR_197="\033[38;5;197m"       # Deep Pink 2 (#FF005F)
#FGCOLOR_198="\033[38;5;198m"       # Deep Pink 1 (#FF0087)
#FGCOLOR_199="\033[38;5;199m"       # Deep Pink 1 (#FF00AF)
#FGCOLOR_200="\033[38;5;200m"       # Magenta 2 (#FF00D7)
FGCOLOR_201="\033[38;5;201m"       # Magenta 1 (#FF00FF)
#FGCOLOR_202="\033[38;5;202m"       # Orange Red 1 (#FF5F00)
#FGCOLOR_203="\033[38;5;203m"       # Indian Red 1 (#FF5F5F)
#FGCOLOR_204="\033[38;5;204m"       # Indian Red 1 (#FF5F87)
#FGCOLOR_205="\033[38;5;205m"       # Hot Pink (#FF5FAF)
#FGCOLOR_206="\033[38;5;206m"       # Hot Pink (#FF5FD7)
#FGCOLOR_207="\033[38;5;207m"       # Medium Orchid 1 (#FF5FFF)
#FGCOLOR_208="\033[38;5;208m"       # Dark Orange (#FF8700)
#FGCOLOR_209="\033[38;5;209m"       # Salmon 1 (#FF875F)
#FGCOLOR_210="\033[38;5;210m"       # Light Coral (#FF8787)
#FGCOLOR_211="\033[38;5;211m"       # Pale Violet Red 1 (#FF87AF)
#FGCOLOR_212="\033[38;5;212m"       # Orchid 2 (#FF87D7)
#FGCOLOR_213="\033[38;5;213m"       # Orchid 1 (#FF87FF)
#FGCOLOR_214="\033[38;5;214m"       # Orange 1 (#FFAF00)
#FGCOLOR_215="\033[38;5;215m"       # Sandy Brown (#FFAF5F)
#FGCOLOR_216="\033[38;5;216m"       # Light Salmon 1 (#FFAF87)
#FGCOLOR_217="\033[38;5;217m"       # Light Pink 1 (#FFAFAF)
#FGCOLOR_218="\033[38;5;218m"       # Rosa 1 (#FFAFD7)
#FGCOLOR_219="\033[38;5;219m"       # Plum 1 (#FFAFFF)
#FGCOLOR_220="\033[38;5;220m"       # Gold 1 (#FFD700)
#FGCOLOR_221="\033[38;5;221m"       # Light Goldenrod 2 (#FFD75F)
#FGCOLOR_222="\033[38;5;222m"       # Light Goldenrod 2 (#FFD787)
#FGCOLOR_223="\033[38;5;223m"       # Navajo White 1 (#FFD7AF)
#FGCOLOR_224="\033[38;5;224m"       # Misty Rose 1 (#FFD7D7)
#FGCOLOR_225="\033[38;5;225m"       # Thistle 1 (#FFD7FF)
#FGCOLOR_226="\033[38;5;226m"       # Yellow 1 (#FFFF00)
#FGCOLOR_227="\033[38;5;227m"       # Light Goldenrod 1 (#FFFF5F)
FGCOLOR_228="\033[38;5;228m"       # Khaki 1 (#FFFF87)
#FGCOLOR_229="\033[38;5;229m"       # Wheat 1 (#FFFFAF)
#FGCOLOR_230="\033[38;5;230m"       # Cornsilk 1 (#FFFFD7)
#FGCOLOR_231="\033[38;5;231m"       # Grey 100 (#FFFFFF)
#FGCOLOR_232="\033[38;5;232m"       # Grey 3 (#080808)
#FGCOLOR_233="\033[38;5;233m"       # Grey 7 (#121212)
#FGCOLOR_234="\033[38;5;234m"       # Grey 11 (#1C1C1C)
#FGCOLOR_235="\033[38;5;235m"       # Grey 15 (#262626)
#FGCOLOR_236="\033[38;5;236m"       # Grey 19 (#303030)
#FGCOLOR_237="\033[38;5;237m"       # Grey 23 (#3A3A3A)
#FGCOLOR_238="\033[38;5;238m"       # Grey 27 (#444444)
#FGCOLOR_239="\033[38;5;239m"       # Grey 30 (#4E4E4E)
#FGCOLOR_240="\033[38;5;240m"       # Grey 35 (#585858)
#FGCOLOR_241="\033[38;5;241m"       # Grey 39 (#626262)
#FGCOLOR_242="\033[38;5;242m"       # Grey 42 (#6C6C6C)
#FGCOLOR_243="\033[38;5;243m"       # Grey 46 (#767676)
#FGCOLOR_244="\033[38;5;244m"       # Grey 50 (#808080)
#FGCOLOR_245="\033[38;5;245m"       # Grey 54 (#8A8A8A)
#FGCOLOR_246="\033[38;5;246m"       # Grey 58 (#949494)
#FGCOLOR_247="\033[38;5;247m"       # Grey 62 (#9E9E9E)
#FGCOLOR_248="\033[38;5;248m"       # Grey 66 (#A8A8A8)
#FGCOLOR_249="\033[38;5;249m"       # Grey 70 (#B2B2B2)
#FGCOLOR_250="\033[38;5;250m"       # Grey 74 (#BCBCBC)
#FGCOLOR_251="\033[38;5;251m"       # Grey 78 (#C6C6C6)
#FGCOLOR_252="\033[38;5;252m"       # Grey 82 (#D0D0D0)
#FGCOLOR_253="\033[38;5;253m"       # Grey 85 (#DADADA)
#FGCOLOR_254="\033[38;5;254m"       # Grey 89 (#E4E4E4)
#FGCOLOR_255="\033[38;5;255m"       # Grey 93 (#EEEEEE)

#----------------------------------------------------------------------#

BG_HEADER_1='\033[48;5;183m'
FG_BG_HEADER='\033[48;5;54;38;5;231m'

#--------------- STYLES -----------------------------------------------#

HIGHLIGHT="$FGCOLOR_201"
OK="$FGCOLOR_46"
ERR="$FGCOLOR_160"
WARN="$FGCOLOR_228"
SIG="$FGCOLOR_93"
LIST="$FGCOLOR_228"
DEBUG="$FGCOLOR_195"
REMOVE="\033[1A\r\033[2K"
NC='\033[0m'

#--------------- Head element ----------------------------------------#

Menu_Header(){
	printf "\n${BG_HEADER_1}%*s${NC}\n" "$TXT_WIDTH" >&2
	printf "%b%*s%b" "$FG_BG_HEADER" "$TXT_WIDTH" "$1" "$NC" >&2
	printf "\n${BG_HEADER_1}%*s${NC}\n" "$TXT_WIDTH" >&2
}

#OutHeadline(){
#	printf '\n%*s\n' "$TXT_WIDTH" | tr ' ' '-'
#	printf "${HIGHLIGHT}%b${NC}" "Step: "
#	printf "%b\n" " $1"
#	printf '%*s\n' "$TXT_WIDTH" | tr ' ' '-'
#}


#--------------- Out log ---------------------------------------------#


DebugLog() {
	if [[ "$ONOFF_DEBUG" == "ON" ]]; then
		local message="$1"
		local level="$2"
		local date
		local day
		local time
		local stack
		local log
		local trenn="_"
		
		[[ "$level" == "START" ]] && trenn="#"
		[[ "$level" == "END" ]] && trenn="_"
		trenn="$trenn"
		level="${level:-DEFAULT}"
		day="$(date +%A )"
		date="$( date +%F )"
		time="$( date +%T )"
		
		log="[$level]\t\t\t$day $date $time"
		stack="${FUNCNAME[*]}"
		stack="${stack#* }"
		stack="[STACK ]\t${stack// / << }"
		line="In line: ${LINENO[*]}"
		message="[MESSAGE]\t$message"
		message="$log\n$stack\t$line\n$message"
		
		[[ "$trenn" == "#" || "trenn" == __ ]] && \
		printf '%*s\n' "$TXT_WIDTH" | tr " " "$trenn" >> "$ERR_LOG"
		printf "%b\n\n" "$message"  >> "$ERR_LOG"
		[[ "$trenn" == "#" || "trenn" == __ ]] && \
		printf '%*s\n' "$TXT_WIDTH" | tr " " "$trenn" >> "$ERR_LOG"
		
		
		if [[ "ONOFF_DEBUG_TOUT" == "ON" ]]; then
			printf "$FGCOLOR_195%b$NC\n" "$text" >&2
		fi
		
	fi
	
}

#--------------- Out remove text --------------------------------------#

#deletes n rows above
OutDeleteRowsAbove(){
	local n=$1
	tput cuu $n >&2 
	tput ed >&2
}

OutDeleteFromToEnd(){
	local n=$1
	tput cup $n 0 >&2
	tput ed >&2
}	

#--------------- Out text ---------------------------------------------#

Out(){
	local text=("$@") 
	DebugLog "${text[*]}" "INFO" 
	
	printf "%b\n" "${text[*]}" | fold -s -w "$TXT_WIDTH" >&2
}

OutOk(){
	local text=("$@")
	DebugLog "${text[*]}" "INFO" 
	
	printf "%b\n" "${OK}${text[*]}${NC}" | fold -s -w "$TXT_WIDTH" >&2
}

OutErr(){
	local text=("$@")
	DebugLog "${text[*]}" "ERROR" 
	
	printf "%b\n" "${ERR}${text[*]}$NC" | fold -s -w "$TXT_WIDTH" >&2
}

OutWarn(){
	local text="$1"
	DebugLog "${text[*]}" "WARNING" 
	
	printf "%b\n" "${WARN}${text[*]}${NC}" | fold -s -w "$TXT_WIDTH" >&2
}

OutH1(){
	local text=("$@")
	DebugLog "${text[*]}" "INFO" 
	
	printf "%b\n" "${HIGHLIGHT}${text[*]}${NC}" | fold -s -w "$TXT_WIDTH" >&2
}

#--------------- Out text indended ------------------------------------#
#Options:
#print indented text with optional bullet points
# use "lst" $2 to activate bullet points


Out_i(){
	local text="$1"
	local list="$2" 
	
	local strng="${LIST}-${NC} "
	[[ $list != "lst" ]] && strng=""
	printf "%b\n" "${strng} $text" | fold -s -w "$TXT_WIDTH" | sed '1,$s/^/\t/' >&2
}

OutOk_i(){
	local text="$1"
	local list="$2"
	
	local strng="${LIST}+${NC} "
	[[ $list != "lst" ]] && strng=""
	printf "${strng}${OK}%b${NC}\n" "$text" | fold -s -w "$TXT_WIDTH" | sed '1,$s/^/\t/'>&2
	
	printf "%s\n" "$text" >> "$ERR_LOG"
}


OutWarn_i(){
	local text="$1"
	local list="$2"
	DebugLog "\$1 text: $text \$2 list: $list" "WANRING" 
	
	local strng="${LIST}!${NC} "
	[[ $list != "lst" ]] && strng=""
	printf "${strng}${WARN}%b${NC}\n" "$text" | fold -s -w "$TXT_WIDTH" | sed '1,$s/^/\t/'>&2
	printf "%s\n" "$text" >> "$ERR_LOG"
}

OutErr_i(){
	local text="$1"
	local list="$2"
	DebugLog "\$1 text: $text \$2 list: $list" "ERROR" 
	
	local strng="${LIST}-${NC} "
	[[ $list != "lst" ]] && strng=""
	printf "${strng}${ERR}%b${NC}\n" "$text" | fold -s -w "$TXT_WIDTH" | sed '1,$s/^/\t/'>&2
}


#---------------- Out list vertical  ----------------------------------#

#prints 4 array elements per line with counter
OutListFourColumns() {
    local array=("$@")
    local columns=4
    local col_width=$(( "$TXT_WIDTH" / columns ))
    local element
    local text
    local i=0
    DebugLog "${array[*]}" "INFO" 
    
	for element in "${array[@]}"; do
        ((i++))

        element="${element##*/}"
        text="$element"

        if (( ${#text} > col_width - 1 )); then
            text="${text:0:$((col_width - 1))}"
        fi

       printf "%b[%s]%b %-*s" "$HIGHLIGHT" "${i}" "$NC" "$(( col_width - ${#n} - 3 ))" "$text" >&2

        if (( i % columns == 0 )); then
            printf "\n" >&2
        fi
    done

    if (( i % columns != 0 )); then
        printf "\n" >&2
    fi
}

#---------------- Out effects line  -----------------------------------#


#prints a simple line
OutLine(){
	printf "${HIGHLIGHT}%*s${NC}\n" "$TXT_WIDTH" | tr ' ' '_' >&2
}

OutLineErr(){
	printf "${ERR}%*s${NC}\n" "$TXT_WIDTH" | tr ' ' '_' >&2
}


#growing line cols*0.01 sec
OutSleepLine(){
	local style="$1"
	local -n color="$style"
	local i
	
	OutLine
	tput cuu  1 >&2
	
	printf "${color}%b" >&2
	for (( i=1; i <= "$TXT_WIDTH"; i++ )); do
		printf "$color%b" "_" >&2
		sleep 0.01
	done
	
	printf "$NC\n" >&2
	n=$i
	tput cud 1 >&2

}

#$1=remove let the line delete herself
StateLine(){
	local option="$1"
	if [[ "$STATE" == "OK" ]]; then
		OutSleepLine "OK"
	elif [[ "$STATE" == "WARN" ]]; then
		OutSleepLine "WARN"
	elif [[ "$STATE" == "ERR" ]]; then
		OutSleepLine "ERR"
	else
		OutSleepLine "SIG"
	fi
	[[ "$option" == "remove" ]] && OutDeleteRowsAbove 2
}

#---------------- Out effects blink  ----------------------------------#

OutBlinkCenter(){
	local text="$1"
	local times="$2"
	local p
	local i
	times="${times:-2}"
	p="$(( (TXT_WIDTH - ${#text}) / 2 ))"
	p="%-${p}s%b\n"
	

	printf "\n" >&2
	for (( i=1; i <= $times; i++ )); do
		printf "${HIGHLIGHT}%*s${NC}\n" "$TXT_WIDTH" | tr ' ' '.' >&2
		printf "$p" " " "${SIG} $text ${NC}" >&2
		printf "${HIGHLIGHT}%*s${NC}\n" "$TXT_WIDTH" | tr ' ' '.' >&2
		sleep 0.33
		(( i < $times )) && OutDeleteRowsAbove 3
		sleep 0.33
	done
	printf "\n" >&2
	
}

#---------------- Out effects color switch  ---------------------------#

OutColorSwitchLineWise(){
	local c_one="$1"
	local c_two="$2"
	shift 2
	local -a array=("$@")
	local i=0
	local element colorswitch
	
	for element in "${array[@]}"; do
		(( i++ ))
		
		colorswitch="$c_one"
		(( i % 2 == 0 )) && colorswitch="$c_two"
		
		printf '%b\t%s%b\n' "$colorswitch" "$element" "$NC" >&2
		sleep 0.1
	done
}
