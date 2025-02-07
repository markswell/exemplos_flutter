import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_appbar.dart';
import 'package:shop/model/product.dart';
import 'package:shop/model/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _urlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg == null) return;

      final product = arg as Product;
      _formData['id'] = product.id;
      _formData['name'] = product.name;
      _formData['description'] = product.description;
      _formData['preco'] = product.price;
      _formData['imageUrl'] = product.imageUrl;

      _imageUrlController.text = product.imageUrl;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool _isValideUrlImage(String url) {
    bool isValideUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool isValideFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValideUrl && isValideFile;
  }

  Future<void> _submitForm() async {
    final isValide = _formKey.currentState?.validate() ?? false;

    if (!isValide) return;

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
    } catch (onError) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro'),
          content: Text('Ocorreu um erro para salvar o produto'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = CustomAppBar.create("Forulário de Produtos", context);

    appBar.actions!.add(
      IconButton(
        onPressed: _submitForm,
        icon: Icon(Icons.save),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            initialValue: _formData['name']?.toString(),
                            onSaved: (name) => _formData['name'] = name ?? '',
                            validator: (name) {
                              if (name!.trim().isEmpty) {
                                return 'O nome não deve estar vazio';
                              }

                              if (name.trim().length < 3) {
                                return 'O nome deve ter pelo menos 3 caracteres';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'nome',
                            ),
                            style: TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_priceFocus);
                            },
                          ),
                          TextFormField(
                            initialValue: _formData['preco']?.toString(),
                            onSaved: (preco) =>
                                _formData['preco'] = double.parse(preco ?? '0'),
                            validator: (preco) {
                              final priceString = preco ?? '';
                              final price = double.parse(priceString) ?? -1;
                              if (price <= 0) return 'Informe um preço válido';
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'preço',
                            ),
                            style: TextStyle(color: Colors.black),
                            focusNode: _priceFocus,
                            keyboardType: TextInputType.numberWithOptions(),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocus);
                            },
                          ),
                          TextFormField(
                            initialValue: _formData['description']?.toString(),
                            onSaved: (description) =>
                                _formData['description'] = description ?? '',
                            validator: (decription) {
                              if (decription!.trim().isEmpty) {
                                return 'A descrição não deve estar vazia';
                              }

                              if (decription.trim().length < 5) {
                                return 'A descrição deve ter pelo menos 5 caracteres';
                              }

                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Descrição'),
                            focusNode: _descriptionFocus,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_urlFocus);
                            },
                            maxLines: 3,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onSaved: (urlImage) =>
                                      _formData['urlImage'] = urlImage ?? '',
                                  validator: (url) {
                                    final imageUrl = url ?? '';
                                    if (!_isValideUrlImage(imageUrl)) {
                                      return 'Url inválida';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'url da imagem',
                                  ),
                                  focusNode: _urlFocus,
                                  controller: _imageUrlController,
                                  style: TextStyle(color: Colors.black),
                                  // textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onFieldSubmitted: (_) => _submitForm(),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: _imageUrlController.text.isEmpty
                                    ? Text('informe a url')
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network(
                                            _imageUrlController.text,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),
    );
  }
}
