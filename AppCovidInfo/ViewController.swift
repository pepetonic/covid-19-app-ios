//
//  ViewController.swift
//  AppCovidInfo
//
//  Created by Mac5 on 14/12/20.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelPais: UILabel!
    @IBOutlet weak var labelTotalCasos: UILabel!
    @IBOutlet weak var labelDefunciones: UILabel!
    @IBOutlet weak var labelRecuperados: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cargar Api al iniciar la app
        cargarInfoPrincipal()
    }
    
    func cargarInfoPrincipal(){
        let urlAPI = URL(string: "https://corona.lmao.ninja/v3/covid-19/all")
        //let urlAPI = URL(string: "https://corona.lmao.ninja/v3/covid-19/countries/mexico")
        
        let peticion = URLRequest(url: urlAPI!)
        
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
            //
            if error != nil {
                print(error!)
            }else {
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    //let pais = json["country"] as! String
                    let casos = json["cases"] as! Int
                    let muertes = json["deaths"] as! Int
                    let recuperados = json["recovered"] as! Int
                    
                    //let subjson = json ["countryInfo"] as! [String: Any]
                    //let img = subjson ["flag"] as! String
                    let pais = "Global"
                    if pais == ""{
                        DispatchQueue.main.sync {
                            self.labelPais.text = "Error"
                        }
                    }else{
                        DispatchQueue.main.sync {
                            self.labelPais.text = "Stituación \(pais)"
                            self.labelTotalCasos.text = "Total de casos: \(String(casos))"
                            self.labelDefunciones.text = "Total de defunciones: \( String(muertes))"
                            self.labelRecuperados.text = "Recuperados: \(String(recuperados))"
                        }
                                     
                    
                    }
                    
                    
                } catch{
                    print("Error al procesar el Json \(error.localizedDescription)")
                }
            }
            
        }
        tarea.resume()
    }

    func buscarInfoPais(country: String){
        let urlAPI = URL(string: "https://corona.lmao.ninja/v3/covid-19/countries/\(country)")
        let peticion = URLRequest(url: urlAPI!)
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
            if error != nil {
                print(error!)
            }else {
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    let pais = json["country"] as! String
                    let casos = json["cases"] as! Int
                    let muertes = json["deaths"] as! Int
                    let recuperados = json["recovered"] as! Int
                    
                    //let subjson = json ["countryInfo"] as! [String: Any]
                    //let img = subjson ["flag"] as! String
                    
                    if pais == ""{
                        DispatchQueue.main.sync {
                            self.labelPais.text = "Error"
                        }
                    }else{
                        DispatchQueue.main.sync {
                            self.labelPais.text = "Stituación \(pais)"
                            self.labelTotalCasos.text = "Total de casos: \(String(casos))"
                            self.labelDefunciones.text = "Total de defunciones: \( String(muertes))"
                            self.labelRecuperados.text = "Recuperados: \(String(recuperados))"
                        }
                                     
                    
                    }
                    
                    
                } catch{
                    print("Error al procesar el Json \(error.localizedDescription)")
                }
            }
            
        }
        tarea.resume()
    }
    @IBAction func buscarPais(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Buscar país", message: "Escriba el nombre del país en Inglés", preferredStyle: .alert)
        
        alert.addTextField { (paisAlert) in
            paisAlert.placeholder = "Pais"
        }
        
        let actionAceptar = UIAlertAction(title: "Buscar", style: .default) { (_) in
            guard let pais = alert.textFields?.first?.text else { return }
            
            if pais == ""{
                let alerta = UIAlertController(title: "Error", message: "Llena el campo de texto", preferredStyle: .alert)
                let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(aceptar)
                self.present(alerta,animated: true, completion: nil)
            }else {
                
            }
        }
        
        let actionCancelar = UIAlertAction (title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(actionAceptar)
        alert.addAction(actionCancelar)
        
        present(alert,animated: true, completion:nil)
    }
}

