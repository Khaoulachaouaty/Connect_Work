// lib/features/admin/employees/presentation/views/admin_employee_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/employee_model.dart';
import '../cubit/employee_cubit.dart';
import 'widgets/employee_form/form_handle_bar.dart';
import 'widgets/employee_form/form_header.dart';
import 'widgets/employee_form/form_text_field.dart';
import 'widgets/employee_form/form_password_field.dart';
import 'widgets/employee_form/form_buttons.dart';

class AdminEmployeeForm extends StatefulWidget {
  final EmployeeModel? employee;
  final ScrollController scrollController;

  const AdminEmployeeForm({
    super.key,
    this.employee,
    required this.scrollController,
  });

  @override
  State<AdminEmployeeForm> createState() => _AdminEmployeeFormState();
}

class _AdminEmployeeFormState extends State<AdminEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _functionController = TextEditingController();
  final _departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _emailController.text = widget.employee!.email;
      _nameController.text = widget.employee!.fullName;
      _phoneController.text = widget.employee!.phoneNumber ?? '';
      _functionController.text = widget.employee!.function ?? '';
      _departmentController.text = widget.employee!.department ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _functionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.employee == null) {
        context.read<EmployeeCubit>().createEmployee(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          function: _functionController.text.trim().isEmpty ? null : _functionController.text.trim(),
          department: _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
        );
      } else {
        final data = <String, dynamic>{};
        if (_nameController.text != widget.employee!.fullName) data['fullName'] = _nameController.text;
        if (_phoneController.text != (widget.employee!.phoneNumber ?? '')) data['phoneNumber'] = _phoneController.text;
        if (_functionController.text != (widget.employee!.function ?? '')) data['function'] = _functionController.text;
        if (_departmentController.text != (widget.employee!.department ?? '')) data['department'] = _departmentController.text;
        if (data.isNotEmpty) context.read<EmployeeCubit>().updateEmployee(widget.employee!.id, data);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const FormHandleBar(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  FormHeader(isEditing: isEditing),
                  const SizedBox(height: 24),
                  FormTextField(
                    controller: _nameController,
                    label: 'Nom complet',
                    icon: Icons.person,
                    required: true,
                    hint: 'Entrez le nom complet',
                  ),
                  const SizedBox(height: 16),
                  FormTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                    hint: 'exemple@entreprise.com',
                  ),
                  if (!isEditing) ...[
                    const SizedBox(height: 16),
                    FormPasswordField(controller: _passwordController),
                  ],
                  const SizedBox(height: 16),
                  FormTextField(
                    controller: _phoneController,
                    label: 'Téléphone',
                    icon: Icons.phone,
                    required: false,
                    keyboardType: TextInputType.phone,
                    hint: 'Optionnel',
                  ),
                  const SizedBox(height: 16),
                  FormTextField(
                    controller: _functionController,
                    label: 'Fonction',
                    icon: Icons.work,
                    required: false,
                    hint: 'Ex: Développeur',
                  ),
                  const SizedBox(height: 16),
                  FormTextField(
                    controller: _departmentController,
                    label: 'Département',
                    icon: Icons.business,
                    required: false,
                    hint: 'Ex: IT',
                  ),
                  const SizedBox(height: 32),
                  FormButtons(
                    onSubmit: _submit,
                    isEditing: isEditing,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}