import 'package:beacon/models/room/room.dart';
import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/controllers/navigator_provider.dart';
import 'package:beacon/repositories/room_repository.dart';
import 'package:beacon/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  final int toRoomId;
  final RoomRepository roomRepository;
  
  const NavigationPage({
    super.key, 
    required this.toRoomId, 
    required this.roomRepository
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late NavigatorProvider _navigatorProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 2. Salve a referência aqui. O didChangeDependencies roda logo após o initState
    // e sempre que as dependências mudam, mas a árvore ainda está estável.
    _navigatorProvider = context.read<NavigatorProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Apenas inicia a voz e carrega grafos, mas NÃO deve setar initialized = true no provider
      context.read<NavigatorProvider>().initializeNavigation();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Safe check opcional, mas recomendável
    });
    // Garante que paramos a voz ao sair
    _navigatorProvider.resetNavigation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BeaconProvider, NavigatorProvider>(
      builder: (context, beaconProvider, navProvider, child) {
        
        // 1. Obter localização atual
        final currentBeacon = beaconProvider.getNearestBeacon;
        if (currentBeacon?.room.value == null) {
           currentBeacon?.room.loadSync();
        }
        final Room? currentRoom = currentBeacon?.room.value;

        // 2. Lógica de Controle (Side Effects)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          
          // Cenário A: Tenho onde estou, mas a rota ainda não foi calculada (flag initialized deve ser false aqui)
          if (currentRoom != null && !navProvider.initialized) {
            // Verifica se não estamos tentando ir para o lugar onde já estamos
            if (currentRoom.id == widget.toRoomId) {
               // Já está no destino antes de começar
               // Pode tratar isso aqui ou deixar o fluxo normal
            }
            navProvider.setRouteInstructions(currentRoom.id, widget.toRoomId);
          }

          // Cenário B: Navegação ativa, verificar progresso
          if (navProvider.initialized) {
            navProvider.checkProgress(
              currentRoom?.id,
              () {
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed(Routes.roomPage.path);
                }
              },
            );
          }
        });

        // 3. Renderização da UI
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Instruções de Navegação',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),

              // Se não inicializado OU se inicializado mas sem instruções (erro ou carregando)
              if (!navProvider.initialized || (navProvider.instructions.isEmpty && navProvider.initialized))
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Calculando rota..."),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCurrentStepCard(context, navProvider),

                        const SizedBox(height: 24),

                        Expanded(
                          child: ListView.builder(
                            itemCount: navProvider.instructions.length,
                            itemBuilder: (context, index) {
                              return _buildInstructionTile(
                                context, 
                                index, 
                                navProvider.currentStepIndex, 
                                navProvider.instructions[index]
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),
                        Text(
                          'Local atual: ${currentRoom?.name ?? 'Procurando...'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStepCard(BuildContext context, NavigatorProvider provider) {
    // CORREÇÃO AQUI: Só mostra "Destino Alcançado" se a lista NÃO for vazia
    // e o indice realmente chegou ao fim.
    
    bool isFinished = provider.currentStepIndex >= provider.instructions.length;
    
    if (provider.instructions.isEmpty) {
        return const SizedBox(); // Não mostra nada se não tem rota
    }

    if (!isFinished) {
      return Card(
        elevation: 4,
        child: ListTile(
          leading: const Icon(Icons.navigation, size: 32),
          title: Text(
            'Próximo passo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            provider.instructions[provider.currentStepIndex],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Card(
        color: Colors.green.shade100,
        child: const ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Destino alcançado 🎉'),
        ),
      );
    }
  }

  Widget _buildInstructionTile(BuildContext context, int index, int currentIndex, String instruction) {
    final isDone = index < currentIndex;
    final isCurrent = index == currentIndex;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDone
            ? Colors.green
            : isCurrent
                ? Colors.blue
                : Colors.grey,
        child: isDone
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
      ),
      title: Text(
        instruction,
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
          color: isDone ? Colors.grey : null,
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
