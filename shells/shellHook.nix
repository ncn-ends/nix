''
  rrservdir(){
    cd ~/code/2_rr/HCMServer
  }
  rrwebdir(){
    cd ~/code/2_rr/EdluminUI
  }
  open-rider() {
    rider $1 &>/dev/null &
  }
  echo "
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
          ▜███▙       ▜███▙  ▟███▛        
           ▜███▙       ▜███▙▟███▛            
            ▜███▙       ▜██████▛             
     ▟█████████████████▙ ▜████▛     ▟▙      
    ▟███████████████████▙ ▜███▙    ▟██▙    
           ▄▄▄▄▖           ▜███▙  ▟███▛      
          ▟███▛             ▜██▛ ▟███▛       
         ▟███▛               ▜▛ ▟███▛         
▟███████████▛                  ▟██████████▙   
▜██████████▛                  ▟███████████▛  
      ▟███▛ ▟▙               ▟███▛          
     ▟███▛ ▟██▙             ▟███▛          
    ▟███▛  ▜███▙           ▝▀▀▀▀           
    ▜██▛    ▜███▙ ▜██████████████████▛     
     ▜▛     ▟████▙ ▜████████████████▛     
           ▟██████▙       ▜███▙          
          ▟███▛▜███▙       ▜███▙      
         ▟███▛  ▜███▙       ▜███▙     
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘        

rrservdir = opens RR server directory
rrwebdir = opens RR web client directory
open-rider = opens rider at specified directory
  "
''