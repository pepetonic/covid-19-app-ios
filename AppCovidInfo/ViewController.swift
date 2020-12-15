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
        let peticion = URLRequest(url: urlAPI!)
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
            if error != nil {
                print(error!)
            }else {
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    let casos = json["cases"] as! Int
                    let muertes = json["deaths"] as! Int
                    let recuperados = json["recovered"] as! Int
                    let pais = "Global"
                
                    if pais == ""{
                        let alerta = UIAlertController(title: "Error", message: "Llena el campo de texto", preferredStyle: .alert)
                        let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                        alerta.addAction(aceptar)
                        self.present(alerta,animated: true, completion: nil)
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
                    
                    //let message = json [] if pagesSubJson.keys.first == "-1"
                    let jsonn = json as! [String: Any]
                    if jsonn.keys.first == "message"  {
                        DispatchQueue.main.sync {
                            let alerta = UIAlertController(title: "Error", message: "Llena el campo de texto con un pais valido o en Inglés", preferredStyle: .alert)
                            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            alerta.addAction(aceptar)
                            self.present(alerta,animated: true, completion: nil)
                        }
                    }else{
                        let pais = json["country"] as! String
                        let casos = json["cases"] as! Int
                        let muertes = json["deaths"] as! Int
                        let recuperados = json["recovered"] as! Int
                        
                        let subjson = json ["countryInfo"] as! [String: Any]
                        let urlImg = subjson ["flag"] as! String
                        let imgUrl = URL(string: urlImg)
                        if pais == ""{
                            let alerta = UIAlertController(title: "Error", message: "Llena el campo de texto", preferredStyle: .alert)
                            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            alerta.addAction(aceptar)
                            self.present(alerta,animated: true, completion: nil)
                        }else{
                            DispatchQueue.main.sync {
                                self.labelPais.text = "Stituación \(pais)"
                                self.labelTotalCasos.text = "Total de casos: \(String(casos))"
                                self.labelDefunciones.text = "Total de defunciones: \( String(muertes))"
                                self.labelRecuperados.text = "Recuperados: \(String(recuperados))"
                            }
                            self.obtenerImage (url: imgUrl!)
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
                self.buscarInfoPais(country: pais)
            }
        }
        
        let actionCancelar = UIAlertAction (title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(actionAceptar)
        alert.addAction(actionCancelar)
        
        present(alert,animated: true, completion:nil)
    }
    
    func obtenerImage (url: URL){
        print("Download Started")
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    self?.imageView.image = UIImage(data: data)
                }
        }
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }}

/*
 print("Download Started")
     getData(from: url) { data, response, error in
         guard let data = data, error == nil else { return }
         print(response?.suggestedFilename ?? url.lastPathComponent)
         print("Download Finished")
         DispatchQueue.main.async() { [weak self] in
             self?.imageView.image = UIImage(data: data)
         }
 }
 ////////
*/
